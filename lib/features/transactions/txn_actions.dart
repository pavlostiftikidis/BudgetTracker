import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/utils/clock.dart';
import 'package:pulse/core/widgets/undo_snackbar.dart';
import 'package:pulse/data/ids.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/data/repositories/recurring_repository.dart';
import 'package:pulse/data/repositories/txn_repository.dart';
import 'package:pulse/domain/recurring_schedule.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'txn_actions.g.dart';

/// Validation failures shown under the composer.
enum TxnError { amountRequired, amountTooLarge, sameAccount, accountRequired, categoryRequired }

TxnError? validateTxn({
  required TxnKind kind,
  required Money amount,
  required String? accountId,
  String? toAccountId,
  String? categoryId,
  bool categoryRequired = false,
}) {
  switch (validateAmount(amount)) {
    case AmountError.required:
      return TxnError.amountRequired;
    case AmountError.tooLarge:
      return TxnError.amountTooLarge;
    case null:
      break;
  }
  if (accountId == null) return TxnError.accountRequired;
  if (kind == TxnKind.transfer) {
    if (toAccountId == null) return TxnError.accountRequired;
    if (toAccountId == accountId) return TxnError.sameAccount;
  } else if (categoryRequired && categoryId == null) {
    return TxnError.categoryRequired;
  }
  return null;
}

@Riverpod(keepAlive: true)
TxnActions txnActions(Ref ref) =>
    TxnActions(ref.watch(txnRepositoryProvider), ref.watch(recurringRepositoryProvider), ref.watch(clockProvider));

/// Writes that span more than one repository.
class TxnActions {
  new(this._txns, this._rules, this._clock);

  final TxnRepository _txns;
  final RecurringRepository _rules;
  final Clock _clock;

  /// Creates a transaction. A date of today keeps the current time; any
  /// other day is stored at noon.
  Future<Txn> add({
    required TxnKind kind,
    required Money amount,
    required String accountId,
    required DateTime day,
    String? toAccountId,
    String? categoryId,
    String? title,
    String? note,
  }) async {
    final now = _clock.now();
    final date = isSameDay(day, now) ? now : DateTime(day.year, day.month, day.day, 12);
    final txn = Txn(
      id: newId(),
      kind: kind,
      amountCents: amount.cents,
      accountId: accountId,
      toAccountId: kind == TxnKind.transfer ? toAccountId : null,
      categoryId: kind == TxnKind.transfer ? null : categoryId,
      title: _clean(title),
      date: date,
      note: _clean(note),
      createdAt: now,
      updatedAt: now,
    );
    await _txns.add(txn);
    return txn;
  }

  /// Saves an edited transaction. [repeatMonthly] turning on creates a
  /// monthly rule anchored on the transaction's day; turning off removes
  /// the rule.
  Future<void> saveEdit({
    required Txn original,
    required Txn edited,
    required bool repeatMonthly,
    required String fallbackTitle,
  }) async {
    var t = edited.copyWith(title: _clean(edited.title), note: _clean(edited.note));
    final hadRule = original.recurringRuleId != null;
    if (repeatMonthly && !hadRule && !t.isTransfer) {
      final now = _clock.now();
      final day = dateOnly(t.date);
      final rule = RecurringRule(
        id: newId(),
        title: t.title ?? fallbackTitle,
        kind: t.kind,
        amountCents: t.amountCents,
        accountId: t.accountId,
        categoryId: t.categoryId,
        note: t.note,
        frequency: Frequency.monthly,
        dayOfMonth: day.day,
        startDate: day,
        nextDueDate: addMonthsAnchored(day, 1, day.day),
        createdAt: now,
        updatedAt: now,
      );
      await _rules.save(rule);
      t = t.copyWith(recurringRuleId: rule.id, occurrenceKey: dayKey(day));
    } else if (!repeatMonthly && hadRule) {
      await _rules.delete(original.recurringRuleId!);
      t = t.copyWith(recurringRuleId: null, occurrenceKey: null);
    }
    await _txns.update(t);
  }

  Future<void> softDelete(String id) => _txns.softDelete(id);

  Future<void> restore(String id) => _txns.restore(id);

  /// Next occurrence after [day] for a monthly rule anchored on it.
  static DateTime nextMonthly(DateTime day) =>
      RecurringSchedule.firstOnOrAfter(frequency: Frequency.monthly, date: addDays(day, 1), dayOfMonth: day.day);

  static String? _clean(String? s) => (s == null || s.trim().isEmpty) ? null : s.trim();
}

/// Soft-deletes [id], buzzes, and offers "Αναίρεση" for five seconds.
/// Works even if the calling screen is popped right after.
Future<void> deleteWithUndo(
  BuildContext context,
  TxnActions actions, {
  required String id,
  required String name,
}) async {
  final show = undoSnackbarPresenter(context, name: name, onUndo: () => actions.restore(id));
  await actions.softDelete(id);
  await HapticFeedback.mediumImpact();
  show();
}
