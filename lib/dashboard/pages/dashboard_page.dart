import 'package:flutter/material.dart';

import 'package:erp_fi/contracts/pages/contract_workspace_page.dart';
import 'package:erp_fi/customers/pages/customer_page.dart';
import 'package:erp_fi/erp_shell/data/erp_sample_data.dart';
import 'package:erp_fi/erp_shell/pages/placeholder_workspace_page.dart';
import 'package:erp_fi/erp_shell/widgets/erp_sidebar.dart';
import 'package:erp_fi/payments/pages/payment_workspace_page.dart';
import 'package:erp_fi/theme/app_colors.dart';
import 'dashboard_overview_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedItem = erpMenuItems[_selectedIndex];
    final showCenteredSectionTitle = selectedItem.id == 'customer';

    return Scaffold(
      backgroundColor: AppColors.canvas,
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: ErpSidebar(
          selectedIndex: _selectedIndex,
          items: erpMenuItems,
          onSelect: _selectIndex,
        ),
      ),
      appBar: AppBar(
        centerTitle: showCenteredSectionTitle,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: showCenteredSectionTitle
            ? Text(
                selectedItem.label,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Francis Interior ERP',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  Text(
                    selectedItem.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.heroTop, AppColors.canvas],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buildBody(selectedItem.id),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(String sectionId) {
    return switch (sectionId) {
      'dashboard' => const DashboardOverviewPage(),
      'customer' => const CustomerPage(),
      'contract' => const ContractWorkspacePage(),
      'payment' => const PaymentWorkspacePage(),
      'commission' => const PlaceholderWorkspacePage(
        title: 'Commission Management',
        description:
            'Assign staff commission percentages, connect them to contracts, and track payout completion.',
      ),
      'materials' => const PlaceholderWorkspacePage(
        title: 'Material Management',
        description:
            'Define project material requirements before procurement or stock usage.',
      ),
      'inventory' => const PlaceholderWorkspacePage(
        title: 'Inventory Management',
        description:
            'Check warehouse stock, reserve materials, and monitor stock movement by project.',
      ),
      'purchase_order' => const PlaceholderWorkspacePage(
        title: 'Purchase Order Management',
        description:
            'Create supplier purchase orders when required materials are unavailable in stock.',
      ),
      'logistics' => const PlaceholderWorkspacePage(
        title: 'Logistics & Delivery',
        description:
            'Plan delivery schedules, installation dates, and final project handover.',
      ),
      'reports' => const PlaceholderWorkspacePage(
        title: 'Reports & Monitoring',
        description:
            'View project health, payment performance, revenue movement, and completion tracking.',
      ),
      _ => const PlaceholderWorkspacePage(
        title: 'Settings',
        description:
            'Configure system preferences, account roles, and workflow defaults.',
      ),
    };
  }

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
