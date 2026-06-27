import 'package:flutter/material.dart';

import 'package:erp_fi/erp_shell/data/erp_sample_data.dart';
import 'package:erp_fi/erp_shell/widgets/erp_data_table_card.dart';
import 'package:erp_fi/erp_shell/widgets/erp_panel.dart';
import 'package:erp_fi/erp_shell/widgets/erp_section_heading.dart';
import 'package:erp_fi/erp_shell/widgets/erp_simple_search_bar.dart';
import 'package:erp_fi/erp_shell/widgets/erp_top_header.dart';

class CustomerWorkspacePage extends StatelessWidget {
  const CustomerWorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ErpTopHeader(
            title: 'Customer',
            emphasis: 'Management',
            actionLabel: 'Add Customer',
          ),
          const SizedBox(height: 20),
          ErpPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ErpSectionHeading(
                  title: 'Customer Register',
                  subtitle:
                      'Register customers and keep commercial records ready before contract creation.',
                ),
                const SizedBox(height: 18),
                const ErpSimpleSearchBar(hint: 'Search customer...'),
                const SizedBox(height: 18),
                ErpDataTableCard(
                  columns: const ['Customer ID', 'Company', 'PIC', 'Status'],
                  rows: customerRows
                      .map(
                        (customer) => [
                          customer.id,
                          customer.company,
                          customer.pic,
                          customer.status,
                        ],
                      )
                      .toList(),
                  statusColumn: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
