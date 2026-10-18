import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/core/theme/keys.dart';
import 'package:pulse/data/models/enums.dart';

export 'enums.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class Account with _$Account {
  const factory({
    required String id,
    required String name,
    required AccountType type,
    @Default(0) int openingBalanceCents,
    @Default(ColorKey.sky) ColorKey colorKey,

    /// Credit card: balance may go negative and is shown in coral.
    @Default(false) bool isCredit,
    int? creditLimitCents,

    /// Day of month the card statement is due ("λήξη 5 Νοε").
    int? statementDay,

    /// Last four digits shown as "••4417".
    String? last4,

    /// Savings target ("Στόχος €5.000 · 65%").
    int? goalCents,
    @Default(false) bool archived,
    @Default(0) int sortOrder,
  }) = _Account;
  const new _();

  factory fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

  Money get openingBalance => Money(openingBalanceCents);
}

@freezed
abstract class TxnCategory with _$TxnCategory {
  const factory({
    required String id,
    required String name,
    required CategoryKind kind,
    required ColorKey colorKey,
    required IconKey iconKey,
    int? monthlyLimitCents,
    @Default(0) int sortOrder,
    @Default(false) bool archived,
  }) = _TxnCategory;
  const new _();

  factory fromJson(Map<String, dynamic> json) => _$TxnCategoryFromJson(json);

  Money? get monthlyLimit => monthlyLimitCents == null ? null : Money(monthlyLimitCents!);

  bool get hasLimit => (monthlyLimitCents ?? 0) > 0;
}

@freezed
abstract class Txn with _$Txn {
  const factory({
    required String id,
    required TxnKind kind,

    /// Always positive; [kind] says which way the money moved.
    required int amountCents,
    required String accountId,

    required DateTime date,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Destination account, transfers only.
    String? toAccountId,

    /// Null for transfers.
    String? categoryId,

    /// Merchant or short title ("Σκλαβενίτης"); falls back to the category.
    String? title,
    String? note,
    String? recurringRuleId,

    /// "yyyy-MM-dd" of the recurring occurrence this was created for.
    String? occurrenceKey,
    String? receiptPath,
    DateTime? deletedAt,
  }) = _Txn;
  const new _();

  factory fromJson(Map<String, dynamic> json) => _$TxnFromJson(json);

  Money get amount => Money(amountCents);

  /// Effect on totals: −amount for expenses, +amount for income, 0 for
  /// transfers (they never count as income or expense).
  Money get signedAmount => switch (kind) {
    TxnKind.expense => -amount,
    TxnKind.income => amount,
    TxnKind.transfer => Money.zero,
  };

  bool get isTransfer => kind == TxnKind.transfer;
}

@freezed
abstract class RecurringRule with _$RecurringRule {
  const factory({
    required String id,

    /// Name shown in the list ("Ενοίκιο").
    required String title,
    required TxnKind kind,
    required int amountCents,
    required String accountId,
    required Frequency frequency,
    required DateTime startDate,
    required DateTime nextDueDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? categoryId,
    String? note,

    /// Months for [Frequency.everyNMonths], weeks for weekly, years for
    /// yearly; 1 for monthly.
    @Default(1) int interval,

    /// Anchor day for month-based frequencies (clamped in short months).
    int? dayOfMonth,

    /// 1 = Monday … 7 = Sunday, weekly only.
    int? weekday,
    @Default(true) bool active,
  }) = _RecurringRule;
  const new _();

  factory fromJson(Map<String, dynamic> json) => _$RecurringRuleFromJson(json);

  Money get amount => Money(amountCents);
}

@freezed
abstract class AppSettings with _$AppSettings {
  const factory({
    @Default(0) int monthlyIncomeCents,
    @Default(PaydayKind.first) PaydayKind paydayKind,
    @Default(1) int paydayDay,
    @Default('EUR') String currency,

    /// Shown as initials in the Home avatar.
    String? displayName,
  }) = _AppSettings;
  const new _();

  factory fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  Money get monthlyIncome => Money(monthlyIncomeCents);

  Payday get payday => Payday(paydayKind, paydayDay.clamp(1, 31));
}
