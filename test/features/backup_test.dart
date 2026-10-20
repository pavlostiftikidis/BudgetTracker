import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:pulse/app/router.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/demo_seed.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/prefs/app_prefs.dart';
import 'package:pulse/data/repositories/backup_repository.dart';
import 'package:pulse/features/settings/backup.dart';
import 'package:pulse/features/settings/settings_screen.dart';

import '../helpers/fixtures.dart';
import '../helpers/pump_app.dart';

void main() {
  // Each test copies between two in-memory databases.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late Directory tmp;
  late AppDatabase source;
  late AppDatabase target;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('pulse-backup-test-');
    source = memoryDb();
    target = memoryDb();
  });

  tearDown(() async {
    await source.close();
    await target.close();
    await tmp.delete(recursive: true);
  });

  /// Demo data plus one transaction with a receipt on disk and one
  /// soft-deleted transaction.
  Future<DataSnapshot> seedSource() async {
    await seedDemoData(source, now: t0);
    final repo = DriftBackupRepository(source);
    final data = await repo.snapshot();
    final receipt = File(p.join(tmp.path, 'old-receipts', 'r1-1.jpg'));
    await receipt.create(recursive: true);
    await receipt.writeAsBytes([1, 2, 3, 4]);
    final accountId = data.accounts.first.id;
    await repo.replaceAll(
      data.copyWith(
        txns: [
          ...data.txns,
          txn(account: accountId, cents: 1234, title: 'Με απόδειξη').copyWith(receiptPath: receipt.path),
          txn(account: accountId, cents: 999, deletedAt: t0),
        ],
      ),
    );
    return await repo.snapshot();
  }

  /// Lists in id order, so two snapshots compare by content alone.
  DataSnapshot byId(DataSnapshot d) => d.copyWith(
    accounts: d.accounts.sortedBy((a) => a.id),
    categories: d.categories.sortedBy((c) => c.id),
    recurringRules: d.recurringRules.sortedBy((r) => r.id),
    txns: d.txns.sortedBy((t) => t.id),
  );

  File zipWith(Map<String, String> entries) {
    final file = File(p.join(tmp.path, 'custom.zip'));
    final archive = Archive();
    for (final MapEntry(:key, :value) in entries.entries) {
      archive.add(ArchiveFile.string(key, value));
    }
    file.writeAsBytesSync(ZipEncoder().encode(archive));
    return file;
  }

  group('backup file', () {
    test('round trip restores every row and the receipts', () async {
      final original = await seedSource();
      expect(original.txns.where((t) => t.deletedAt != null), isEmpty, reason: 'soft-deleted rows are left out');
      expect(original.recurringRules, isNotEmpty);

      final zip = File(p.join(tmp.path, 'backup.zip'));
      await writeBackup(original, t0, zip);
      final backup = await readBackup(zip);
      expect(backup.createdAt, t0);

      // The target already has data of its own; it is replaced.
      await seedDemoData(target, now: t0.subtract(const Duration(days: 400)));
      final receiptsDir = Directory(p.join(tmp.path, 'new-receipts'));
      await File(p.join(receiptsDir.path, 'stale.jpg')).create(recursive: true);
      await restoreBackup(zip, backup, repository: DriftBackupRepository(target), receiptsDir: receiptsDir);

      final restored = await DriftBackupRepository(target).snapshot();
      final withReceipt = restored.txns.singleWhere((t) => t.receiptPath != null);
      expect(withReceipt.receiptPath, p.join(receiptsDir.path, 'r1-1.jpg'));
      expect(File(withReceipt.receiptPath!).readAsBytesSync(), [1, 2, 3, 4]);
      expect(File(p.join(receiptsDir.path, 'stale.jpg')).existsSync(), isFalse);
      expect(Directory('${receiptsDir.path}.restore').existsSync(), isFalse);

      final originalPath = original.txns.singleWhere((t) => t.receiptPath != null).receiptPath;
      expect(
        byId(
          restored.copyWith(
            txns: [
              for (final t in restored.txns)
                if (t.receiptPath == null) t else t.copyWith(receiptPath: originalPath),
            ],
          ),
        ),
        byId(original),
      );
    });

    test('a receipt whose file is gone is dropped', () async {
      final original = await seedSource();
      final path = original.txns.singleWhere((t) => t.receiptPath != null).receiptPath!;
      File(path).deleteSync();

      final zip = File(p.join(tmp.path, 'backup.zip'));
      await writeBackup(original, t0, zip);
      await restoreBackup(
        zip,
        await readBackup(zip),
        repository: DriftBackupRepository(target),
        receiptsDir: Directory(p.join(tmp.path, 'new-receipts')),
      );
      final restored = await DriftBackupRepository(target).snapshot();
      expect(restored.txns.where((t) => t.receiptPath != null), isEmpty);
      expect(restored.txns, hasLength(original.txns.length));
    });

    test('files that are not backups are rejected', () async {
      Future<BackupProblem?> problem(File f) async {
        try {
          await readBackup(f);
          return null;
        } on BackupException catch (e) {
          return e.problem;
        }
      }

      final text = File(p.join(tmp.path, 'notes.zip'))..writeAsStringSync('not a zip');
      expect(await problem(text), BackupProblem.notABackup);
      expect(await problem(zipWith({'other.json': '{}'})), BackupProblem.notABackup);
      expect(await problem(zipWith({'backup.json': '{"format":"other","version":1}'})), BackupProblem.notABackup);
      final valid = jsonDecode(encodeBackup(const DataSnapshot(settings: AppSettings()), t0)) as Map<String, dynamic>;
      expect(
        await problem(
          zipWith({
            'backup.json': jsonEncode({...valid, 'version': kBackupVersion + 1}),
          }),
        ),
        BackupProblem.newerVersion,
      );
      expect(
        await problem(
          zipWith({
            'backup.json': jsonEncode({
              ...valid,
              'data': {
                'settings': <String, Object?>{},
                'accounts': [
                  {'id': 'a', 'name': 'X', 'type': 'spaceship'},
                ],
              },
            }),
          }),
        ),
        BackupProblem.notABackup,
      );
      expect(
        await problem(zipWith({'backup.json': encodeBackup(const DataSnapshot(settings: AppSettings()), t0)})),
        isNull,
      );
    });

    test('a backup the database rejects changes nothing', () async {
      await seedDemoData(target, now: t0);
      final before = await DriftBackupRepository(target).snapshot();
      final receiptsDir = Directory(p.join(tmp.path, 'receipts'));
      final kept = File(p.join(receiptsDir.path, 'kept.jpg'))..createSync(recursive: true);

      // A transaction on an account that is not in the file.
      final broken = DataSnapshot(
        settings: const AppSettings(),
        txns: [txn(account: 'missing', cents: 100)],
      );
      final zip = zipWith({'backup.json': encodeBackup(broken, t0), 'receipts/x.jpg': 'x'});
      await expectLater(
        restoreBackup(zip, await readBackup(zip), repository: DriftBackupRepository(target), receiptsDir: receiptsDir),
        throwsA(isA<BackupException>().having((e) => e.problem, 'problem', BackupProblem.failed)),
      );
      expect(byId(await DriftBackupRepository(target).snapshot()), byId(before));
      expect(kept.existsSync(), isTrue);
      expect(File(p.join(receiptsDir.path, 'x.jpg')).existsSync(), isFalse);
    });

    test('entries outside receipts/ are never written', () async {
      final zip = zipWith({
        'backup.json': encodeBackup(const DataSnapshot(settings: AppSettings()), t0),
        'receipts/../escaped.jpg': 'x',
        'receipts/nested/deep.jpg': 'x',
      });
      final receiptsDir = Directory(p.join(tmp.path, 'inner', 'receipts'));
      await restoreBackup(
        zip,
        await readBackup(zip),
        repository: DriftBackupRepository(target),
        receiptsDir: receiptsDir,
      );
      expect(File(p.join(tmp.path, 'inner', 'escaped.jpg')).existsSync(), isFalse);
      expect(receiptsDir.listSync(recursive: true), isEmpty);
    });
  });

  testWidgets('Ρυθμίσεις › Εισαγωγή αντιγράφου replaces the data after confirming', (tester) async {
    final zip = File(p.join(tmp.path, 'backup.zip'));
    await tester.runAsync(() async {
      final data = await seedSource();
      await writeBackup(
        data.copyWith(settings: data.settings.copyWith(displayName: 'Από αντίγραφο')),
        DateTime(2026, 10, 5, 9),
        zip,
      );
    });

    final appDb = memoryDb();
    final container = await pumpPulseApp(
      tester,
      db: appDb,
      prefs: MemoryAppPrefs(onboardingDone: true),
      overrides: [backupPickerProvider.overrideWithValue(_FakePicker(zip))],
    );
    unawaited(container.read(routerProvider).push(Routes.settings));
    await settle(tester);

    await tester.ensureVisible(find.text('Εισαγωγή αντιγράφου'));
    await settle(tester);
    await tester.tap(find.text('Εισαγωγή αντιγράφου'));
    await settle(tester);
    expect(find.textContaining('Αντίγραφο της 5 Οκτ 2026'), findsOneWidget);

    await tester.tap(find.text('Εισαγωγή'));
    for (var i = 0; i < 4; i++) {
      await settle(tester);
    }
    expect(find.text('Τα δεδομένα επανήλθαν από το αντίγραφο.'), findsOneWidget);
    expect(find.text('Από αντίγραφο'), findsOneWidget);
    final restored = await tester.runAsync(() => DriftBackupRepository(appDb).snapshot());
    expect(restored!.accounts, isNotEmpty);
  });
}

class _FakePicker implements BackupPicker {
  new(this.file);

  final File file;

  @override
  Future<File?> pick() async => file;
}
