import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/app/bootstrap.dart';
import 'package:pulse/core/money/amount_input.dart';
import 'package:pulse/core/money/money.dart';
import 'package:pulse/core/theme/pulse_theme.dart';
import 'package:pulse/core/widgets/money_keypad.dart';
import 'package:pulse/l10n/app_localizations.dart';

/// Hosts the keypad with a live readout of the typed amount.
class _Host extends StatefulWidget {
  const new();

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  AmountInput value = const AmountInput();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text('display:${value.display}'),
      Text('cents:${value.value.cents}'),
      MoneyKeypad(value: value, onChanged: (v) => setState(() => value = v)),
    ],
  );
}

void main() {
  setUpAll(initLocale);

  Future<void> pumpKeypad(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      theme: PulseTheme.dark(),
      locale: const Locale('el'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: const Scaffold(body: _Host()),
    ),
  );

  Future<void> press(WidgetTester tester, String keys) async {
    for (final k in keys.split('')) {
      final label = switch (k) {
        ',' => 'Υποδιαστολή',
        '<' => 'Διαγραφή ψηφίου',
        _ => k,
      };
      await tester.tap(find.byKey(ValueKey('key-$label')));
      await tester.pump();
    }
  }

  testWidgets('typing enforces two decimals and groups thousands', (tester) async {
    await pumpKeypad(tester);
    expect(find.text('display:0'), findsOneWidget);

    await press(tester, '1250,509');
    expect(find.text('display:1.250,50'), findsOneWidget);
    expect(find.text('cents:125050'), findsOneWidget);
  });

  testWidgets('at most €99.999,99', (tester) async {
    await pumpKeypad(tester);
    await press(tester, '1234567,999');
    expect(find.text('display:12.345,99'), findsOneWidget);
    await press(tester, '<<<<<<<<<');
    await press(tester, '99999,99');
    expect(find.text('cents:${Money.max.cents}'), findsOneWidget);
  });

  testWidgets('backspace, and long-press to clear', (tester) async {
    await pumpKeypad(tester);
    await press(tester, '42,5<');
    expect(find.text('display:42,'), findsOneWidget);
    await tester.longPress(find.byKey(const ValueKey('key-Διαγραφή ψηφίου')));
    await tester.pump();
    expect(find.text('display:0'), findsOneWidget);
  });

  testWidgets('every key has a spoken label', (tester) async {
    await pumpKeypad(tester);
    for (final label in ['0', '1', '9', 'Υποδιαστολή', 'Διαγραφή ψηφίου']) {
      expect(find.bySemanticsLabel(label), findsOneWidget);
    }
  });
}
