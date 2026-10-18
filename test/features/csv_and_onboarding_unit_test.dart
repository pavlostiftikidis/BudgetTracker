import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/bootstrap.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/period/budget_period.dart';
import 'package:pulse/data/models/models.dart';
import 'package:pulse/data/repositories/account_repository.dart';
import 'package:pulse/data/repositories/category_repository.dart';
import 'package:pulse/data/repositories/settings_repository.dart';
import 'package:pulse/features/onboarding/onboarding_actions.dart';
import 'package:pulse/features/settings/csv_export.dart';
import 'package:pulse/features/transactions/txn_display.dart';
import 'package:pulse/l10n/app_localizations.dart';

import '../helpers/fixtures.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('el'));
  setUpAll(initLocale);

  group('CSV export', () {
    final lookups = Lookups.from(
      [category(id: 'g')],
      [account(id: 'a'), account(id: 's', name: 'Αποταμίευση; "κουμπαράς"')],
    );
    final csv = buildCsv(
      [
        txn(account: 'a', category: 'g', cents: 4280, title: 'Σκλαβενίτης', date: DateTime(2026, 10, 18, 18, 40)),
        txn(account: 'a', cents: 215000, kind: TxnKind.income, title: 'Μισθός', date: DateTime(2026, 10, 1, 8, 30)),
        txn(account: 'a', to: 's', cents: 30000, kind: TxnKind.transfer, date: DateTime(2026, 10, 2, 9)),
        txn(account: 'a', cents: 999, deletedAt: t0),
      ],
      lookups,
      l10n,
    );
    final lines = csv.split('\r\n');

    test('BOM, header, oldest first, deleted rows left out', () {
      expect(csv.startsWith('﻿'), isTrue);
      expect(lines.first, '﻿Ημερομηνία;Τύπος;Τίτλος;Κατηγορία;Λογαριασμός;Προς λογαριασμό;Ποσό (EUR);Σημείωση');
      expect(lines.where((l) => l.isNotEmpty), hasLength(4));
      expect(lines[1], startsWith('2026-10-01 08:30;Έσοδο;Μισθός'));
    });

    test('signed amounts with a decimal comma', () {
      expect(lines[3], '2026-10-18 18:40;Έξοδο;Σκλαβενίτης;Σούπερ μάρκετ;Τρεχούμενος;;-42,80;');
      expect(lines[1], endsWith(';2150,00;'));
    });

    test('fields with separators or quotes are quoted', () {
      expect(lines[2], '2026-10-02 09:00;Μεταφορά;;;Τρεχούμενος;"Αποταμίευση; ""κουμπαράς""";300,00;');
    });
  });

  group('onboarding', () {
    test('draft maths', () {
      const draft = OnboardingDraft();
      expect(draft.totalLimits, const Money(98000));
      expect(draft.leftover, const Money(117000));
      final down = draft.step(SuggestedCategory.entertainment, -1);
      expect(down.limitOf(SuggestedCategory.entertainment), const Money(5000));
      var floor = draft;
      for (var i = 0; i < 10; i++) {
        floor = floor.step(SuggestedCategory.entertainment, -1);
      }
      expect(floor.limitOf(SuggestedCategory.entertainment), Money.zero, reason: 'never negative');
    });

    test('completing twice does not duplicate anything', () async {
      final db = memoryDb();
      addTearDown(db.close);
      Future<void> run() => completeOnboarding(
        draft: const OnboardingDraft(payday: Payday(PaydayKind.custom, 25)),
        settings: DriftSettingsRepository(db),
        categories: DriftCategoryRepository(db),
        accounts: DriftAccountRepository(db),
        l10n: l10n,
      );
      await run();
      await run();
      expect(await db.select(db.categories).get(), hasLength(9));
      expect(await db.select(db.accounts).get(), hasLength(2));
      final s = await DriftSettingsRepository(db).get();
      expect(s.payday, const Payday(PaydayKind.custom, 25));
      expect(s.monthlyIncome, const Money(215000));
    });
  });
}
