import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/mappers.dart';
import 'package:pulse/data/models/models.dart';

abstract interface class CategoryRepository {
  Stream<List<TxnCategory>> watchCategories({bool includeArchived = false});

  /// Live (not soft-deleted) transaction count per category id.
  Stream<Map<String, int>> watchTxnCounts();

  Future<void> save(TxnCategory category);

  /// Saves several at once (onboarding defaults).
  Future<void> saveAll(List<TxnCategory> categories);

  Future<void> reorder(List<String> idsInOrder);

  /// Archives when the category is referenced by any transaction (even a
  /// soft-deleted one) or recurring rule, deletes it otherwise.
  /// Returns true if archived.
  Future<bool> archiveOrDelete(String id);
}

class DriftCategoryRepository implements CategoryRepository {
  new(this._db);

  final AppDatabase _db;

  @override
  Stream<List<TxnCategory>> watchCategories({bool includeArchived = false}) =>
      _db.categoriesDao.watchAll(includeArchived: includeArchived).map((rows) => [for (final r in rows) r.toModel()]);

  @override
  Stream<Map<String, int>> watchTxnCounts() => _db.categoriesDao.watchTxnCounts();

  @override
  Future<void> save(TxnCategory category) => _db.categoriesDao.upsert(category.toCompanion());

  @override
  Future<void> saveAll(List<TxnCategory> categories) => _db.transaction(() async {
    for (final c in categories) {
      await _db.categoriesDao.upsert(c.toCompanion());
    }
  });

  @override
  Future<void> reorder(List<String> idsInOrder) => _db.categoriesDao.reorder(idsInOrder);

  @override
  Future<bool> archiveOrDelete(String id) => _db.transaction(() async {
    final usedByRule = await (_db.select(_db.recurringRules)..where((r) => r.categoryId.equals(id))).get();
    if (usedByRule.isNotEmpty || await _db.txnsDao.countForCategory(id) > 0) {
      await _db.categoriesDao.setArchived(id, archived: true);
      return true;
    }
    await _db.categoriesDao.deleteById(id);
    return false;
  });
}
