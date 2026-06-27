import 'package:flutter/material.dart';

class ErpTopHeader extends StatelessWidget {
  const ErpTopHeader({
    required this.title,
    required this.emphasis,
    required this.actionLabel,
    super.key,
  });

  final String title;
  final String emphasis;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(emphasis, style: theme.textTheme.headlineMedium),
            ],
          ),
        ),
        if (MediaQuery.sizeOf(context).width >= 760)
          FilledButton(onPressed: () {}, child: Text(actionLabel)),
      ],
    );
  }
}
