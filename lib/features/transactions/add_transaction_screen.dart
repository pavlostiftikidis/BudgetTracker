import 'package:flutter/material.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/page_header.dart';
import 'package:pulse/core/widgets/placeholder_body.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';

class AddTransactionScreen extends StatelessWidget {
  const new({this.transfer = false, super.key});

  final bool transfer;

  @override
  Widget build(BuildContext context) {
    final title = transfer ? context.l10n.addTransfer : context.l10n.navAdd;
    return PulseScaffold(
      body: Column(
        children: [
          PageHeader(title: title),
          Expanded(child: PlaceholderBody(name: title)),
        ],
      ),
    );
  }
}
