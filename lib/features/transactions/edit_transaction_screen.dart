import 'package:flutter/material.dart';
import 'package:pulse/core/utils/context_ext.dart';
import 'package:pulse/core/widgets/page_header.dart';
import 'package:pulse/core/widgets/placeholder_body.dart';
import 'package:pulse/core/widgets/pulse_scaffold.dart';

class EditTransactionScreen extends StatelessWidget {
  const new({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    final title = context.l10n.editTitle;
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
