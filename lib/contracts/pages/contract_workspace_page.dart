import 'package:flutter/material.dart';

import 'package:erp_fi/erp_shell/widgets/erp_top_header.dart';
import '../widgets/contract_detail_panel.dart';
import '../widgets/contract_list_panel.dart';

class ContractWorkspacePage extends StatelessWidget {
  const ContractWorkspacePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 1180;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ErpTopHeader(
            title: 'Contract',
            emphasis: 'Workspace',
            actionLabel: 'New Contract',
          ),
          const SizedBox(height: 20),
          isCompact
              ? const Column(
                  children: [
                    ContractListPanel(),
                    SizedBox(height: 16),
                    ContractDetailPanel(),
                  ],
                )
              : const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: ContractListPanel()),
                    SizedBox(width: 16),
                    Expanded(flex: 4, child: ContractDetailPanel()),
                  ],
                ),
        ],
      ),
    );
  }
}
