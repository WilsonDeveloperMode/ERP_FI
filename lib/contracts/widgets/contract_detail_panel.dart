import 'package:flutter/material.dart';

import 'package:erp_fi/erp_shell/data/erp_sample_data.dart';
import 'package:erp_fi/erp_shell/widgets/erp_data_table_card.dart';
import 'package:erp_fi/erp_shell/widgets/erp_key_value_grid.dart';
import 'package:erp_fi/erp_shell/widgets/erp_panel.dart';
import 'package:erp_fi/erp_shell/widgets/erp_section_heading.dart';

class ContractDetailPanel extends StatelessWidget {
  const ContractDetailPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ErpPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14),
                label: const Text('Back'),
              ),
              const Spacer(),
              FilledButton.tonal(onPressed: () {}, child: const Text('Edit')),
            ],
          ),
          const SizedBox(height: 18),
          const ErpSectionHeading(
            title: 'Contract Detail',
            subtitle: 'FI-2026-001',
          ),
          const SizedBox(height: 18),
          const ErpKeyValueGrid(entries: contractDetailEntries),
          const SizedBox(height: 22),
          Text(
            'Assigned Staff & Commission',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const ErpDataTableCard(
            columns: [
              'Staff Name',
              'Department',
              'Commission (%)',
              'Commission Amount',
            ],
            rows: [
              ['Michelle', 'Sales', '40%', 'Rp 500,000,000'],
              ['Tanty', 'Design', '35%', 'Rp 437,500,000'],
              ['Kevin', 'Project', '25%', 'Rp 312,500,000'],
            ],
          ),
        ],
      ),
    );
  }
}
