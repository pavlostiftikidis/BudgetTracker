import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/theme/pulse_text.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/buttons.dart';
import 'package:pulse/core/widgets/empty_state.dart';
import 'package:pulse/core/widgets/icon_tile.dart';
import 'package:pulse/core/widgets/mono_label.dart';
import 'package:pulse/core/widgets/page_header.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';
import 'package:pulse/core/widgets/surface_card.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/providers.dart';
import 'package:pulse/domain/balances.dart';
import 'package:pulse/features/accounts/account_display.dart';
import 'package:pulse/features/accounts/account_form_sheet.dart';
import 'package:pulse/features/transactions/transfer_widgets.dart';

class AccountsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = context.l10n;
    final accounts = ref.watch(accountsProvider).value;
    final balances = ref.watch(balancesProvider).value ?? const <String, Money>{};
    final today = ref.watch(clockProvider).now();

    if (accounts == null) return const PulseScaffold(body: SizedBox.shrink());
    final total = totalBalance(accounts, balances);

    return PulseScaffold(
      body: Column(
        children: [
          PageHeader(title: l10n.accountsTitle, trailing: const [ThemeToggleButton()]),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + MediaQuery.paddingOf(context).bottom),
              children: [
                MonoLabel(l10n.accountsTotalLabel),
                const SizedBox(height: 6),
                Semantics(
                  label: '${l10n.accountsTotalLabel}: ${total.format()}',
                  excludeSemantics: true,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      total.format(),
                      style: PulseText.hero.copyWith(
                        fontSize: 52,
                        letterSpacing: -2.6,
                        color: total.isNegative ? c.coralInk : c.text,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _AccentButton(
                        icon: LucideIcons.arrowLeftRight,
                        label: l10n.accountsTransfer,
                        onTap: () => showTransferSheet(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlineButtonPill(
                        icon: LucideIcons.plus,
                        label: l10n.accountsNew,
                        onPressed: () => showAccountForm(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (accounts.isEmpty)
                  EmptyState(icon: LucideIcons.wallet, title: l10n.validationAccountRequired)
                else
                  for (final a in accounts) ...[
                    _AccountCard(
                      account: a,
                      balance: balances[a.id] ?? a.openingBalance,
                      subtitle: accountSubtitle(a, balances[a.id] ?? a.openingBalance, today, l10n),
                      onTap: () => showAccountForm(context, account: a),
                    ),
                    const SizedBox(height: 10),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const new({required this.account, required this.balance, required this.subtitle, required this.onTap});

  final Account account;
  final Money balance;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final negative = balance.isNegative;
    return Semantics(
      button: true,
      label: [account.name, subtitle, balance.format(), if (negative) l10n.accountNegativeSemantics].join(', '),
      excludeSemantics: true,
      child: SurfaceCard(
        radius: Radii.cardSm,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        onTap: onTap,
        child: Row(
          children: [
            IconTile(icon: accountIcon(account.type), color: account.colorKey, size: 44, radius: 14, filled: true),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(account.name, style: PulseText.title.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: PulseText.small.copyWith(fontWeight: FontWeight.w500, color: c.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              balance.format(),
              style: PulseText.amount.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: negative ? c.coralInk : c.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccentButton extends StatelessWidget {
  const new({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      child: Material(
        color: c.accent,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 52),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: c.onAccent),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    style: PulseText.label.copyWith(fontSize: 15, fontWeight: FontWeight.w800, color: c.onAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
