import 'package:pulse/core/money/money.dart';
import 'package:pulse/data/models/models.dart';

/// Money that moved through an account for one kind of transaction.
typedef AccountFlow = ({String accountId, TxnKind kind, bool incoming, int totalCents});

/// Balance = opening + income − expenses − transfers out + transfers in.
/// Credit cards simply go negative.
Map<String, Money> balancesFromFlows(Iterable<Account> accounts, Iterable<AccountFlow> flows) {
  final out = {for (final a in accounts) a.id: a.openingBalance};
  for (final f in flows) {
    final current = out[f.accountId];
    if (current == null) continue;
    final delta = switch (f.kind) {
      TxnKind.income => f.totalCents,
      TxnKind.expense => -f.totalCents,
      TxnKind.transfer => f.incoming ? f.totalCents : -f.totalCents,
    };
    out[f.accountId] = current + Money(delta);
  }
  return out;
}

/// Same as [balancesFromFlows] but from individual transactions; ignores
/// soft-deleted ones.
Map<String, Money> computeBalances(Iterable<Account> accounts, Iterable<Txn> txns) {
  final flows = <AccountFlow>[];
  for (final t in txns.where((t) => t.deletedAt == null)) {
    flows.add((accountId: t.accountId, kind: t.kind, incoming: false, totalCents: t.amountCents));
    if (t.kind == TxnKind.transfer && t.toAccountId != null) {
      flows.add((accountId: t.toAccountId!, kind: t.kind, incoming: true, totalCents: t.amountCents));
    }
  }
  return balancesFromFlows(accounts, flows);
}

/// Sum over non-archived accounts.
Money totalBalance(Iterable<Account> accounts, Map<String, Money> balances) =>
    accounts.where((a) => !a.archived).map((a) => balances[a.id] ?? a.openingBalance).sum();
