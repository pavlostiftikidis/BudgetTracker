import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/mappers.dart';
import 'package:pulse/data/models/models.dart';

abstract interface class SettingsRepository {
  Stream<AppSettings> watch();

  Future<AppSettings> get();

  Future<void> save(AppSettings settings);

  /// Deletes every account, category, transaction, rule and setting.
  Future<void> wipeAll();
}

class DriftSettingsRepository implements SettingsRepository {
  new(this._db);

  final AppDatabase _db;

  @override
  Stream<AppSettings> watch() => _db.settingsDao.watch().map((r) => r.toModel());

  @override
  Future<AppSettings> get() async => (await _db.settingsDao.get()).toModel();

  @override
  Future<void> save(AppSettings settings) => _db.settingsDao.save(settings.toCompanion());

  @override
  Future<void> wipeAll() => _db.wipe();
}
