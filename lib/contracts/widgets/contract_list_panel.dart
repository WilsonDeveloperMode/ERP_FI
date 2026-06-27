import 'package:flutter/material.dart';

import 'package:erp_fi/erp_shell/data/erp_sample_data.dart';
import 'package:erp_fi/erp_shell/widgets/erp_data_table_card.dart';
import 'package:erp_fi/erp_shell/widgets/erp_panel.dart';
import 'package:erp_fi/erp_shell/widgets/erp_section_heading.dart';
import 'package:erp_fi/erp_shell/widgets/erp_simple_search_bar.dart';

class ContractListPanel extends StatelessWidget {
  const ContractListPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ErpPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ErpSectionHeading(
            title: 'Contract List',
            subtitle: 'View and manage all interior project contracts.',
          ),
          const SizedBox(height: 16),
          const ErpSimpleSearchBar(hint: 'Search contract...'),
          const SizedBox(height: 18),
          ErpDataTableCard(
            columns: const [
              'Contract No.',
              'Customer',
              'Project / Title',
              'Value',
              'Status',
            ],
            rows: contractRows
                .map(
                  (contract) => [
                    contract.contractNo,
                    contract.customer,
                    contract.project,
                    contract.value,
                    contract.status,
                  ],
                )
                .toList(),
            statusColumn: 4,
          ),
        ],
      ),
    );
  }
}
