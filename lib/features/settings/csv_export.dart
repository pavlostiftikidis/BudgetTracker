import 'dart:io';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/features/transactions/txn_display.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

/// Spreadsheet-friendly CSV for Greek Excel / Numbers / Sheets: UTF-8 with a
/// BOM, `;` as separator (`,` is the decimal mark), CRLF line endings, dates
/// as `yyyy-MM-dd HH:mm`, amounts signed with a plain `-` and a decimal
/// comma so they import as numbers.
String buildCsv(List<Txn> txns, Lookups lookups, AppLocalizations l10n) {
  String cell(String? v) {
    final s = v ?? '';
    return s.contains(RegExp('[;"\r\n]')) ? '"${s.replaceAll('"', '""')}"' : s;
  }

  String amount(Txn t) {
    final cents = switch (t.kind) {
      TxnKind.expense => -t.amountCents,
      TxnKind.income || TxnKind.transfer => t.amountCents,
    };
    final abs = cents.abs();
    return '${cents < 0 ? '-' : ''}${abs ~/ 100},${(abs % 100).toString().padLeft(2, '0')}';
  }

  final date = DateFormat('yyyy-MM-dd HH:mm');
  final rows = <List<String?>>[
    ['Ημερομηνία', 'Τύπος', 'Τίτλος', 'Κατηγορία', 'Λογαριασμός', 'Προς λογαριασμό', 'Ποσό (EUR)', 'Σημείωση'],
    for (final t in txns.where((t) => t.deletedAt == null).sortedBy((t) => t.date))
      [
        date.format(t.date),
        switch (t.kind) {
          TxnKind.expense => l10n.addExpense,
          TxnKind.income => l10n.addIncome,
          TxnKind.transfer => l10n.addTransfer,
        },
        t.title,
        lookups.category(t.categoryId)?.name,
        lookups.account(t.accountId)?.name,
        lookups.account(t.toAccountId)?.name,
        amount(t),
        t.note,
      ],
  ];
  return '﻿${rows.map((r) => r.map(cell).join(';')).join('\r\n')}\r\n';
}

/// Writes the CSV to a temporary file and opens the share sheet.
Future<void> exportAndShareCsv(List<Txn> txns, Lookups lookups, AppLocalizations l10n, DateTime now) async {
  final dir = await getTemporaryDirectory();
  final file = File(p.join(dir.path, 'budget-pace-${dayKey(now)}.csv'));
  await file.writeAsString(buildCsv(txns, lookups, l10n), flush: true);
  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path, mimeType: 'text/csv')],
      subject: l10n.exportSubject,
      title: l10n.exportSubject,
    ),
  );
}
