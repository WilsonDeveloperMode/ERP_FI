import 'package:flutter/material.dart';

class ErpStatusLine extends StatelessWidget {
  const ErpStatusLine({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}
