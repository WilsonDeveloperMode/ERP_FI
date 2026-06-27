import 'package:flutter/material.dart';

import 'package:erp_fi/erp_shell/models/erp_record_models.dart';
import 'package:erp_fi/erp_shell/widgets/erp_panel.dart';

class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({required this.card, super.key});

  final SummaryCardData card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 180,
      child: ErpPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.label,
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
            ),
            const SizedBox(height: 12),
            Text(
              card.value,
              style: theme.textTheme.headlineSmall?.copyWith(fontSize: 28),
            ),
          ],
        ),
      ),
    );
  }
}
