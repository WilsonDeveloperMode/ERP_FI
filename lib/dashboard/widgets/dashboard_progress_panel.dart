import 'package:flutter/material.dart';

import 'package:erp_fi/erp_shell/widgets/erp_legend_row.dart';
import 'package:erp_fi/erp_shell/widgets/erp_panel.dart';
import 'package:erp_fi/theme/app_colors.dart';

class DashboardProgressPanel extends StatelessWidget {
  const DashboardProgressPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ErpPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Progress', style: theme.textTheme.titleMedium),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: 0.66,
                        strokeWidth: 12,
                        backgroundColor: AppColors.surfaceTint,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    Text('66%', style: theme.textTheme.headlineSmall),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Column(
                  children: [
                    ErpLegendRow(
                      label: 'Paid',
                      value: '66%',
                      color: AppColors.success,
                    ),
                    SizedBox(height: 12),
                    ErpLegendRow(
                      label: 'Pending',
                      value: '24%',
                      color: AppColors.warning,
                    ),
                    SizedBox(height: 12),
                    ErpLegendRow(
                      label: 'Overdue',
                      value: '10%',
                      color: AppColors.danger,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
