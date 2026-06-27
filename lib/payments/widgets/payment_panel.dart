import 'package:flutter/material.dart';

import 'package:erp_fi/erp_shell/data/erp_sample_data.dart';
import 'package:erp_fi/erp_shell/widgets/erp_data_table_card.dart';
import 'package:erp_fi/erp_shell/widgets/erp_legend_row.dart';
import 'package:erp_fi/erp_shell/widgets/erp_panel.dart';
import 'package:erp_fi/erp_shell/widgets/erp_section_heading.dart';
import 'package:erp_fi/theme/app_colors.dart';

class PaymentPanel extends StatelessWidget {
  const PaymentPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ErpPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ErpSectionHeading(
            title: 'Payment Progress',
            subtitle: 'Contract No. FI-2026-001',
          ),
          const SizedBox(height: 18),
          ErpDataTableCard(
            columns: const ['Stage', 'Due Date', 'Amount', 'Status'],
            rows: paymentRows
                .map(
                  (payment) => [
                    payment.stage,
                    payment.dueDate,
                    payment.amount,
                    payment.status,
                  ],
                )
                .toList(),
            statusColumn: 3,
          ),
          const SizedBox(height: 24),
          Text('Progress Overview', style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: const LinearProgressIndicator(
              value: 0.66,
              minHeight: 12,
              backgroundColor: AppColors.surfaceTint,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '66%',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 18),
          const ErpLegendRow(
            label: 'Paid',
            value: 'Rp 750,000,000 (66%)',
            color: AppColors.success,
          ),
          const SizedBox(height: 10),
          const ErpLegendRow(
            label: 'Pending',
            value: 'Rp 375,000,000 (24%)',
            color: AppColors.warning,
          ),
          const SizedBox(height: 10),
          const ErpLegendRow(
            label: 'Overdue',
            value: 'Rp 0 (10%)',
            color: AppColors.danger,
          ),
        ],
      ),
    );
  }
}
