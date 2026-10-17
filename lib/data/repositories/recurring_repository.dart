import 'package:drift/drift.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/utils/clock.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/db/mappers.dart';
import 'package:pulse/data/ids.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/domain/recurring_schedule.dart';

abstract interface class RecurringRepository {
  Stream<List<RecurringRule>> watchRules();

  Future<RecurringRule?> byId(String id);

  Future<void> save(RecurringRule rule);

  Future<void> setActive(String id, {required bool active});

  Future<void> delete(String id);

  /// Turns every due occurrence up to today into a real transaction and
  /// advances each rule's next due date. Idempotent: an occurrence is keyed
  /// by (rule id, date), so running it twice never duplicates. Paused rules
  /// are skipped. Returns how many transactions were created.
  Future<int> materializeDue();
}

class DriftRecurringRepository implements RecurringRepository {
  new(this._db, this._clock);

  final AppDatabase _db;
  final Clock _clock;

  @override
  Stream<List<RecurringRule>> watchRules() =>
      _db.recurringDao.watchAll().map((rows) => [for (final r in rows) r.toModel()]);

  @override
  Future<RecurringRule?> byId(String id) async => (await _db.recurringDao.byId(id))?.toModel();

  @override
  Future<void> save(RecurringRule rule) => _db.recurringDao.upsert(rule.toCompanion());

  @override
  Future<void> setActive(String id, {required bool active}) =>
      _db.recurringDao.patch(id, RecurringRulesCompanion(active: Value(active), updatedAt: Value(_clock.now())));

  @override
  Future<void> delete(String id) => _db.recurringDao.deleteById(id);

  @override
  Future<int> materializeDue() {
    final now = _clock.now();
    final today = dateOnly(now);
    return _db.transaction(() async {
      var created = 0;
      for (final row in await _db.recurringDao.dueBefore(addDays(today, 1))) {
        final rule = row.toModel();
        final dates = RecurringSchedule.dueOccurrences(rule, today);
        for (final date in dates) {
          final inserted = await _db.txnsDao.insertOccurrence(
            TxnsCompanion.insert(
              id: newId(),
              kind: rule.kind,
              amountCents: rule.amountCents,
              accountId: rule.accountId,
              categoryId: Value(rule.categoryId),
              title: Value(rule.title),
              date: date,
              note: Value(rule.note),
              recurringRuleId: Value(rule.id),
              occurrenceKey: Value(dayKey(date)),
              createdAt: now,
              updatedAt: now,
            ),
          );
          if (inserted) created++;
        }
        if (dates.isNotEmpty) {
          await _db.recurringDao.patch(
            rule.id,
            RecurringRulesCompanion(
              nextDueDate: Value(RecurringSchedule.advance(rule, dates.last)),
              updatedAt: Value(now),
            ),
          );
        }
      }
      return created;
    });
  }
}
