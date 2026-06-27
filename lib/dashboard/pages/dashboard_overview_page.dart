import 'package:flutter/material.dart';

import 'package:erp_fi/erp_shell/data/erp_sample_data.dart';
import 'package:erp_fi/erp_shell/widgets/erp_top_header.dart';
import '../widgets/dashboard_progress_panel.dart';
import '../widgets/dashboard_status_panel.dart';
import '../widgets/dashboard_summary_card.dart';

class DashboardOverviewPage extends StatelessWidget {
  const DashboardOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 900;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ErpTopHeader(
            title: 'Welcome back,',
            emphasis: 'Michelle',
            actionLabel: 'New Contract',
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: dashboardSummaryCards
                .map((card) => DashboardSummaryCard(card: card))
                .toList(),
          ),
          const SizedBox(height: 20),
          isCompact
              ? const Column(
                  children: [
                    DashboardProgressPanel(),
                    SizedBox(height: 16),
                    DashboardStatusPanel(),
                  ],
                )
              : const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: DashboardProgressPanel()),
                    SizedBox(width: 16),
                    Expanded(flex: 4, child: DashboardStatusPanel()),
                  ],
                ),
        ],
      ),
    );
  }
}
