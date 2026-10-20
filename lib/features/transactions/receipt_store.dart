import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Picks an image and copies it into the app's documents folder
/// (`receipts/<txnId>.<ext>`), so it survives the picker's temp cleanup.
/// Returns the stored path, or null if the user cancelled.
Future<String?> pickAndStoreReceipt(String txnId, {required bool camera}) async {
  final file = await ImagePicker().pickImage(
    source: camera ? ImageSource.camera : ImageSource.gallery,
    maxWidth: 2000,
    imageQuality: 85,
  );
  if (file == null) return null;
  final dir = await receiptsDirectory();
  await dir.create(recursive: true);
  final ext = p.extension(file.path).isEmpty ? '.jpg' : p.extension(file.path);
  final target = p.join(dir.path, '$txnId-${DateTime.now().millisecondsSinceEpoch}$ext');
  await File(file.path).copy(target);
  return target;
}

/// Removes a stored receipt; ignores files that are already gone.
Future<void> deleteReceipt(String? path) async {
  if (path == null) return;
  final f = File(path);
  if (f.existsSync()) await f.delete();
}

/// Where receipts are stored: `receipts/` in the app's documents folder.
Future<Directory> receiptsDirectory() async =>
    Directory(p.join((await getApplicationDocumentsDirectory()).path, 'receipts'));

/// The receipts folder, for Ρυθμίσεις › Επαναφορά δεδομένων and the backup.
abstract interface class ReceiptStorage {
  /// The folder; it may not exist yet.
  Future<Directory> directory();

  /// Removes every stored receipt.
  Future<void> deleteAll();
}

class DocumentsReceiptStorage implements ReceiptStorage {
  const new();

  @override
  Future<Directory> directory() => receiptsDirectory();

  @override
  Future<void> deleteAll() async {
    final dir = await receiptsDirectory();
    if (dir.existsSync()) await dir.delete(recursive: true);
  }
}
