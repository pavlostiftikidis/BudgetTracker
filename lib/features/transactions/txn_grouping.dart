import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/utils/greek.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/features/transactions/txn_display.dart';

enum TxnFilter { all, expenses, income }

final class DayGroup {
  const new({required this.day, required this.items, required this.total});

  final DateTime day;
  final List<TxnView> items;

  /// Income − expenses of the visible rows; transfers count as zero.
  final Money total;
}

/// Accent- and case-insensitive key ("Σκλαβενίτης" ~ "σκλαβενιτης").
String searchKey(String s) => greekUpper(s);

bool matchesFilter(Txn t, TxnFilter f) => switch (f) {
  TxnFilter.all => true,
  TxnFilter.expenses => t.kind == TxnKind.expense,
  TxnFilter.income => t.kind == TxnKind.income,
};

bool matchesQuery(TxnView v, String query) {
  final q = searchKey(query.trim());
  if (q.isEmpty) return true;
  return [v.title, v.categoryName, v.accountLabel, v.txn.note ?? ''].any((field) => searchKey(field).contains(q));
}

/// Groups newest-first [views] by calendar day, keeping order.
List<DayGroup> groupByDay(Iterable<TxnView> views) {
  final groups = <DayGroup>[];
  DateTime? day;
  var items = <TxnView>[];
  void flush() {
    if (day != null && items.isNotEmpty) {
      groups.add(DayGroup(day: day, items: items, total: items.map((v) => v.txn.signedAmount).sum()));
    }
  }

  for (final v in views) {
    final d = dateOnly(v.txn.date);
    if (day == null || d != day) {
      flush();
      day = d;
      items = [];
    }
    items.add(v);
  }
  flush();
  return groups;
}
