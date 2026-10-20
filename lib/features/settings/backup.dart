import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/repositories/backup_repository.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

/// Layout of the backup file. Bump it when the layout changes; files with an
/// older version must keep restoring.
const int kBackupVersion = 1;

const _format = 'pulse-backup';
const _dataEntry = 'backup.json';
const _receiptsEntry = 'receipts';

/// Why a backup could not be restored.
enum BackupProblem {
  /// Not a zip, no `backup.json`, or data that does not parse.
  notABackup,

  /// Made by a newer version of the app.
  newerVersion,

  /// The database rejected the data; nothing was changed.
  failed,
}

class BackupException implements Exception {
  const new(this.problem);

  final BackupProblem problem;

  @override
  String toString() => 'BackupException(${problem.name})';
}

/// A backup that has been read and checked but not applied yet.
typedef Backup = ({DateTime createdAt, DataSnapshot data});

/// Writes a zip to [out]: `backup.json` with [data], and the receipts it
/// references under `receipts/`. Receipt paths are stored relative to the
/// zip, since the documents folder differs between installs; receipts whose
/// file is gone are dropped.
Future<void> writeBackup(DataSnapshot data, DateTime now, File out) async {
  final zip = ZipFileEncoder()..create(out.path);
  try {
    final txns = <Txn>[];
    for (final t in data.txns) {
      final path = t.receiptPath;
      if (path == null || !File(path).existsSync()) {
        txns.add(t.copyWith(receiptPath: null));
        continue;
      }
      final entry = '$_receiptsEntry/${p.basename(path)}';
      await zip.addFile(File(path), entry);
      txns.add(t.copyWith(receiptPath: entry));
    }
    zip.addArchiveFile(ArchiveFile.string(_dataEntry, encodeBackup(data.copyWith(txns: txns), now)));
  } finally {
    await zip.close();
  }
}

/// The `backup.json` text.
String encodeBackup(DataSnapshot data, DateTime now) => jsonEncode({
  'format': _format,
  'version': kBackupVersion,
  'createdAt': now.toIso8601String(),
  'data': data.toJson(),
});

/// Parses `backup.json`; throws [BackupException] if it is not one this
/// version can restore.
Backup decodeBackup(String json) {
  try {
    final map = jsonDecode(json) as Map<String, dynamic>;
    if (map['format'] != _format) throw const BackupException(BackupProblem.notABackup);
    if ((map['version'] as int) > kBackupVersion) throw const BackupException(BackupProblem.newerVersion);
    return (
      createdAt: DateTime.parse(map['createdAt'] as String),
      data: DataSnapshot.fromJson(map['data'] as Map<String, dynamic>),
    );
  } on BackupException {
    rethrow;
  } on FormatException {
    throw const BackupException(BackupProblem.notABackup);
    // Generated fromJson reports bad data as TypeError or ArgumentError.
    // ignore: avoid_catching_errors
  } on Error {
    throw const BackupException(BackupProblem.notABackup);
  }
}

/// Opens the zip at [file] and checks its `backup.json`, changing nothing.
Future<Backup> readBackup(File file) async {
  final input = InputFileStream(file.path);
  try {
    final json = ZipDecoder().decodeStream(input).findFile(_dataEntry)?.readBytes();
    if (json == null) throw const BackupException(BackupProblem.notABackup);
    return decodeBackup(utf8.decode(json));
  } on FormatException {
    // Not a zip, or `backup.json` is not UTF-8.
    throw const BackupException(BackupProblem.notABackup);
  } finally {
    await input.close();
  }
}

/// Replaces all data with [backup], read from the zip at [file] by
/// [readBackup]. Receipts replace the contents of [receiptsDir] and the
/// transactions are pointed at them. The database swap is one transaction,
/// so if it fails ([BackupProblem.failed]) everything stays as it was.
Future<void> restoreBackup(
  File file,
  Backup backup, {
  required BackupRepository repository,
  required Directory receiptsDir,
}) async {
  // Receipts are unpacked next to the live folder first and swapped in only
  // once the database has accepted the data.
  final staging = Directory('${receiptsDir.path}.restore');
  if (staging.existsSync()) await staging.delete(recursive: true);
  await staging.create(recursive: true);

  final unpacked = <String>{};
  final input = InputFileStream(file.path);
  try {
    for (final entry in ZipDecoder().decodeStream(input)) {
      final name = p.posix.basename(entry.name);
      // Only plain files directly under receipts/, so a crafted name
      // ("receipts/../x") can never write outside the folder.
      if (!entry.isFile || entry.name != '$_receiptsEntry/$name' || name.startsWith('.')) continue;
      final out = OutputFileStream(p.join(staging.path, name));
      entry.writeContent(out);
      await out.close();
      unpacked.add(entry.name);
    }
  } on FormatException {
    await staging.delete(recursive: true);
    throw const BackupException(BackupProblem.notABackup);
  } finally {
    await input.close();
  }

  final data = backup.data.copyWith(
    txns: [
      for (final t in backup.data.txns)
        t.copyWith(
          receiptPath: unpacked.contains(t.receiptPath)
              ? p.join(receiptsDir.path, p.posix.basename(t.receiptPath!))
              : null,
        ),
    ],
  );
  try {
    await repository.replaceAll(data);
  } on Exception {
    await staging.delete(recursive: true);
    throw const BackupException(BackupProblem.failed);
  }

  if (receiptsDir.existsSync()) await receiptsDir.delete(recursive: true);
  await staging.rename(receiptsDir.path);
}

/// Lets the user choose a backup zip (Ρυθμίσεις › Εισαγωγή αντιγράφου).
abstract interface class BackupPicker {
  /// A local file with the chosen zip, or null if cancelled.
  Future<File?> pick();
}

class SystemBackupPicker implements BackupPicker {
  const new();

  @override
  Future<File?> pick() async {
    final picked = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: ['zip']);
    if (picked == null) return null;
    if (picked.path case final path?) return File(path);
    // Android can hand back a content URI rather than a path; copy it.
    final out = File(p.join((await getTemporaryDirectory()).path, 'pulse-import.zip'));
    final sink = out.openWrite();
    try {
      await sink.addStream(picked.readAsByteStream());
    } finally {
      await sink.close();
    }
    return out;
  }
}

/// Writes the backup to a temporary file and opens the share sheet, so it
/// can be saved to Files or Drive or sent to another phone.
Future<void> shareBackup(DataSnapshot data, AppLocalizations l10n, DateTime now) async {
  final dir = await getTemporaryDirectory();
  final file = File(p.join(dir.path, 'pulse-backup-${dayKey(now)}.zip'));
  await writeBackup(data, now, file);
  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path, mimeType: 'application/zip')],
      subject: l10n.backupSubject,
      title: l10n.backupSubject,
    ),
  );
}
