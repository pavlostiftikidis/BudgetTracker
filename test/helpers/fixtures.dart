import 'package:drift/native.dart';
import 'package:pulse/core/theme/keys.dart';
import 'package:pulse/data/db/app_database.dart';
import 'package:pulse/data/models/models.dart';

int _seq = 0;
String _id(String prefix) => '$prefix-${_seq++}';

final DateTime t0 = DateTime(2026, 10, 18, 12);

AppDatabase memoryDb() => AppDatabase(NativeDatabase.memory());

Account account({
  String? id,
  String name = 'Τρεχούμενος',
  AccountType type = AccountType.bank,
  int opening = 0,
  bool isCredit = false,
  bool archived = false,
}) => Account(
  id: id ?? _id('acc'),
  name: name,
  type: type,
  openingBalanceCents: opening,
  isCredit: isCredit,
  archived: archived,
);

TxnCategory category({
  String? id,
  String name = 'Σούπερ μάρκετ',
  CategoryKind kind = CategoryKind.expense,
  int? limit,
  bool archived = false,
  ColorKey color = ColorKey.lime,
  IconKey icon = IconKey.cart,
}) => TxnCategory(
  id: id ?? _id('cat'),
  name: name,
  kind: kind,
  colorKey: color,
  iconKey: icon,
  monthlyLimitCents: limit,
  archived: archived,
);

Txn txn({
  required String account,
  required int cents,
  TxnKind kind = TxnKind.expense,
  String? category,
  String? to,
  DateTime? date,
  String? title,
  DateTime? deletedAt,
  String? id,
}) {
  final when = date ?? t0;
  return Txn(
    id: id ?? _id('txn'),
    kind: kind,
    amountCents: cents,
    accountId: account,
    toAccountId: to,
    categoryId: category,
    title: title,
    date: when,
    deletedAt: deletedAt,
    createdAt: when,
    updatedAt: when,
  );
}

RecurringRule rule({
  required String account,
  required DateTime nextDue,
  int cents = 65000,
  String? category,
  Frequency frequency = Frequency.monthly,
  int interval = 1,
  int? dayOfMonth,
  int? weekday,
  bool active = true,
  TxnKind kind = TxnKind.expense,
  String title = 'Ενοίκιο',
  String? id,
}) => RecurringRule(
  id: id ?? _id('rule'),
  title: title,
  kind: kind,
  amountCents: cents,
  accountId: account,
  categoryId: category,
  frequency: frequency,
  interval: interval,
  dayOfMonth: dayOfMonth ?? nextDue.day,
  weekday: weekday,
  startDate: nextDue,
  nextDueDate: nextDue,
  active: active,
  createdAt: t0,
  updatedAt: t0,
);
