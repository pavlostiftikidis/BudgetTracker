import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/domain/balances.dart';

import '../helpers/fixtures.dart';

void main() {
  final checking = account(id: 'checking', opening: 120000);
  final card = account(id: 'card', name: 'Κάρτα', type: AccountType.card, isCredit: true);
  final savings = account(id: 'savings', type: AccountType.savings, opening: 100000);
  final accounts = [checking, card, savings];

  test('opening + income − expenses', () {
    final b = computeBalances(accounts, [
      txn(account: 'checking', cents: 215000, kind: TxnKind.income),
      txn(account: 'checking', cents: 65000),
      txn(account: 'checking', cents: 6840),
    ]);
    expect(b['checking'], const Money(120000 + 215000 - 65000 - 6840));
    expect(b['card'], Money.zero);
    expect(b['savings'], const Money(100000));
  });

  test('transfers move money between accounts and never change the total', () {
    final before = computeBalances(accounts, const []);
    final after = computeBalances(accounts, [
      txn(account: 'checking', to: 'savings', cents: 30000, kind: TxnKind.transfer),
    ]);
    expect(after['checking'], const Money(90000));
    expect(after['savings'], const Money(130000));
    expect(totalBalance(accounts, after), totalBalance(accounts, before));
  });

  test('credit cards go negative and a payoff brings them back', () {
    var b = computeBalances(accounts, [
      txn(account: 'card', cents: 4280),
      txn(account: 'card', cents: 360),
    ]);
    expect(b['card'], const Money(-4640));
    expect(b['card']!.isNegative, isTrue);

    b = computeBalances(accounts, [
      txn(account: 'card', cents: 4280),
      txn(account: 'card', cents: 360),
      txn(account: 'checking', to: 'card', cents: 4640, kind: TxnKind.transfer),
    ]);
    expect(b['card'], Money.zero);
    expect(b['checking'], const Money(120000 - 4640));
  });

  test('soft-deleted transactions are ignored', () {
    final b = computeBalances(accounts, [
      txn(account: 'checking', cents: 5000, deletedAt: t0),
    ]);
    expect(b['checking'], const Money(120000));
  });

  test('flows from SQL and from transactions agree', () {
    final txns = [
      txn(account: 'checking', cents: 215000, kind: TxnKind.income),
      txn(account: 'checking', cents: 1000),
      txn(account: 'checking', to: 'card', cents: 700, kind: TxnKind.transfer),
    ];
    final flows = <AccountFlow>[
      (accountId: 'checking', kind: TxnKind.income, incoming: false, totalCents: 215000),
      (accountId: 'checking', kind: TxnKind.expense, incoming: false, totalCents: 1000),
      (accountId: 'checking', kind: TxnKind.transfer, incoming: false, totalCents: 700),
      (accountId: 'card', kind: TxnKind.transfer, incoming: true, totalCents: 700),
    ];
    expect(balancesFromFlows(accounts, flows), computeBalances(accounts, txns));
  });

  test('archived accounts are left out of the total', () {
    final old = account(id: 'old', opening: 5000, archived: true);
    final all = [...accounts, old];
    expect(totalBalance(all, computeBalances(all, const [])), const Money(220000));
  });
}
