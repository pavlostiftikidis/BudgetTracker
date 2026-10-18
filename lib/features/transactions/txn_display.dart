import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/dates.dart';
import 'package:pulse/core/theme/palette.dart';
import 'package:pulse/core/theme/pulse_colors.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/utils/greek.dart';
import 'package:pulse/core/widgets/icon_tile.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'txn_display.g.dart';

/// Id → model maps, archived rows included, for labelling transactions.
final class Lookups {
  const new({required this.categories, required this.accounts});

  factory from(List<TxnCategory> categories, List<Account> accounts) =>
      Lookups(categories: {for (final c in categories) c.id: c}, accounts: {for (final a in accounts) a.id: a});

  final Map<String, TxnCategory> categories;
  final Map<String, Account> accounts;

  TxnCategory? category(String? id) => id == null ? null : categories[id];
  Account? account(String? id) => id == null ? null : accounts[id];
}

@Riverpod(keepAlive: true)
Future<Lookups> lookups(Ref ref) async {
  final categories = await ref.watch(allCategoriesProvider.future);
  final accounts = await ref.watch(allAccountsProvider.future);
  return Lookups.from(categories, accounts);
}

/// How one transaction reads on screen.
final class TxnView {
  const new({
    required this.txn,
    required this.title,
    required this.categoryName,
    required this.accountLabel,
    required this.amountText,
    required this.color,
    required this.icon,
  });

  final Txn txn;
  final String title;

  /// Category name, or "Μεταφορά" for transfers.
  final String categoryName;

  /// Account name, or "Από → Προς" for transfers.
  final String accountLabel;

  /// "−€42,80", "+€2.150,00", or "€300,00" for transfers.
  final String amountText;
  final ColorKey color;
  final IconData icon;

  String get initial => initialOf(title);

  /// "Σούπερ μάρκετ · Κάρτα".
  String get subtitle => txn.isTransfer ? accountLabel : '$categoryName · $accountLabel';

  /// "Σούπερ μάρκετ · 18:40".
  String get subtitleWithTime => '$categoryName · ${timeOfDay(txn.date)}';

  Color amountColor(PulseColors c) => switch (txn.kind) {
    TxnKind.income => c.accentInk,
    TxnKind.expense => c.text,
    TxnKind.transfer => c.muted,
  };
}

TxnView describeTxn(Txn t, Lookups lookups, AppLocalizations l10n) {
  final category = lookups.category(t.categoryId);
  final account = lookups.account(t.accountId);
  final categoryName = t.isTransfer ? l10n.transferTitle : (category?.name ?? '—');
  final title = (t.title?.trim().isNotEmpty ?? false) ? t.title!.trim() : categoryName;
  final accountLabel = t.isTransfer
      ? l10n.transferRoute(account?.name ?? '—', lookups.account(t.toAccountId)?.name ?? '—')
      : (account?.name ?? '—');
  return TxnView(
    txn: t,
    title: title,
    categoryName: categoryName,
    accountLabel: accountLabel,
    amountText: formatTxnAmount(t.kind, t.amount),
    color: t.isTransfer ? ColorKey.grey : (category?.colorKey ?? ColorKey.grey),
    icon: t.isTransfer ? LucideIcons.arrowLeftRight : (category?.iconKey.icon ?? LucideIcons.tag),
  );
}

/// Expense "−€42,80", income "+€2.150,00", transfer "€300,00".
String formatTxnAmount(TxnKind kind, Money amount) => switch (kind) {
  TxnKind.expense => (-amount).format(),
  TxnKind.income => amount.formatSigned(),
  TxnKind.transfer => amount.format(),
};

/// "Σήμερα", "Χθες", "Τετ, 14 Οκτ".
String dayLabel(DateTime day, DateTime today, AppLocalizations l10n) {
  final diff = daysBetween(day, today);
  if (diff == 0) return l10n.dayToday;
  if (diff == 1) return l10n.dayYesterday;
  if (diff == -1) return l10n.dayTomorrow;
  return dayHeader(day);
}

/// Initial tile + title/subtitle + amount, as used in every list.
class TxnRowContent extends StatelessWidget {
  const new({required this.view, this.withTime = false, this.useIcon = false, super.key});

  final TxnView view;

  /// Subtitle shows the time instead of the account (Home).
  final bool withTime;

  /// Category icon instead of the initial.
  final bool useIcon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        if (useIcon || view.txn.isTransfer)
          IconTile(icon: view.icon, color: view.color)
        else
          IconTile(initial: view.initial, color: view.color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(view.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: PulseText.title),
              const SizedBox(height: 2),
              Text(
                withTime ? view.subtitleWithTime : view.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: PulseText.caption.copyWith(fontSize: 12, color: c.muted),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          view.amountText,
          style: PulseText.amount.copyWith(fontWeight: FontWeight.w800, color: view.amountColor(c)),
        ),
      ],
    );
  }
}

/// Accessible one-line description of a row.
String txnSemantics(TxnView v, AppLocalizations l10n) => l10n.txnSemantics(v.title, v.subtitle, v.amountText);
