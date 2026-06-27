import 'package:flutter/material.dart';

import 'package:erp_fi/erp_shell/widgets/erp_panel.dart';
import 'package:erp_fi/erp_shell/widgets/erp_status_line.dart';

class DashboardStatusPanel extends StatelessWidget {
  const DashboardStatusPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ErpPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contract Status', style: theme.textTheme.titleMedium),
          const SizedBox(height: 18),
          const ErpStatusLine(label: 'Active', value: '28'),
          const SizedBox(height: 12),
          const ErpStatusLine(label: 'Pending', value: '10'),
          const SizedBox(height: 12),
          const ErpStatusLine(label: 'Completed', value: '5'),
          const SizedBox(height: 12),
          const ErpStatusLine(label: 'Cancelled', value: '0'),
        ],
      ),
    );
  }
}
