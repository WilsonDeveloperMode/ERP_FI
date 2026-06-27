import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  static const _menuItems = <_MenuItem>[
    _MenuItem('Dashboard', Icons.dashboard_outlined),
    _MenuItem('Customer', Icons.people_outline_rounded),
    _MenuItem('Contract', Icons.description_outlined),
    _MenuItem('Payment', Icons.credit_card_outlined),
    _MenuItem('Commission', Icons.percent_rounded),
    _MenuItem('Materials', Icons.inventory_2_outlined),
    _MenuItem('Inventory', Icons.warehouse_outlined),
    _MenuItem('Purchase Order', Icons.shopping_cart_checkout_outlined),
    _MenuItem('Logistics', Icons.local_shipping_outlined),
    _MenuItem('Reports', Icons.bar_chart_rounded),
    _MenuItem('Settings', Icons.settings_outlined),
  ];

  static const _summaryCards = <_SummaryCardData>[
    _SummaryCardData('Total Contracts', '120'),
    _SummaryCardData('Active Contracts', '43'),
    _SummaryCardData('Total Revenue', 'Rp 5.2B'),
    _SummaryCardData('Pending Payments', '8'),
  ];

  static const _contracts = <_ContractRow>[
    _ContractRow(
      contractNo: 'FI-2026-001',
      customer: 'PT Nirwana Kharisma',
      project: 'Luxury Apartment',
      value: 'Rp 1,250,000,000',
      status: 'Active',
    ),
    _ContractRow(
      contractNo: 'FI-2026-002',
      customer: 'PT Sentosa Abadi',
      project: 'Office Interior',
      value: 'Rp 800,000,000',
      status: 'Pending',
    ),
    _ContractRow(
      contractNo: 'FI-2026-003',
      customer: 'PT Mega Karya',
      project: 'Villa Project',
      value: 'Rp 700,000,000',
      status: 'Active',
    ),
    _ContractRow(
      contractNo: 'FI-2026-004',
      customer: 'PT Jaya Makmur',
      project: 'Showroom Interior',
      value: 'Rp 450,000,000',
      status: 'Active',
    ),
    _ContractRow(
      contractNo: 'FI-2026-005',
      customer: 'PT Golden Land',
      project: 'Model Unit',
      value: 'Rp 960,000,000',
      status: 'Completed',
    ),
  ];

  static const _payments = <_PaymentRow>[
    _PaymentRow('Stage 1', '01 May 2026', 'Rp 750,000,000', 'Paid'),
    _PaymentRow('Stage 2', '01 Jun 2026', 'Rp 375,000,000', 'Paid'),
    _PaymentRow('Stage 3', '01 Jul 2026', 'Rp 375,000,000', 'Pending'),
  ];

  static const _customers = <_CustomerRow>[
    _CustomerRow('CUS-001', 'PT Nirwana Kharisma', 'Michelle', 'Active'),
    _CustomerRow('CUS-002', 'PT Golden Land', 'Kevin', 'Prospect'),
    _CustomerRow('CUS-003', 'PT Sentosa Abadi', 'Tanty', 'Active'),
    _CustomerRow('CUS-004', 'PT Jaya Makmur', 'Rendy', 'Onboarding'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        child: _Sidebar(
          selectedIndex: _selectedIndex,
          items: _menuItems,
          onSelect: _selectIndex,
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Francis Interior ERP',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            Text(
              _menuItems[_selectedIndex].label,
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
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return switch (_selectedIndex) {
      0 => const _DashboardOverview(),
      1 => const _CustomerWorkspace(),
      2 => const _ContractListWorkspace(),
      3 => const _PaymentWorkspace(),
      4 => const _PlaceholderWorkspace(
        title: 'Commission Management',
        description:
            'Assign staff commission percentages, connect them to contracts, and track payout completion.',
      ),
      5 => const _PlaceholderWorkspace(
        title: 'Material Management',
        description:
            'Define project material requirements before procurement or stock usage.',
      ),
      6 => const _PlaceholderWorkspace(
        title: 'Inventory Management',
        description:
            'Check warehouse stock, reserve materials, and monitor stock movement by project.',
      ),
      7 => const _PlaceholderWorkspace(
        title: 'Purchase Order Management',
        description:
            'Create supplier purchase orders when required materials are unavailable in stock.',
      ),
      8 => const _PlaceholderWorkspace(
        title: 'Logistics & Delivery',
        description:
            'Plan delivery schedules, installation dates, and final project handover.',
      ),
      9 => const _PlaceholderWorkspace(
        title: 'Reports & Monitoring',
        description:
            'View project health, payment performance, revenue movement, and completion tracking.',
      ),
      _ => const _PlaceholderWorkspace(
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

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.selectedIndex,
    required this.items,
    required this.onSelect,
  });

  final int selectedIndex;
  final List<_MenuItem> items;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.sidebar,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.sidebarOverlay.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/francis-interior-logo.png',
                  height: 42,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Francis\nInterior',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'MAIN MENU',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = index == selectedIndex;
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    onSelect(index);
                    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.26)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: selected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.78),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.label,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: selected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.78),
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardOverview extends StatelessWidget {
  const _DashboardOverview();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 900;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopHeader(
            title: 'Welcome back,',
            emphasis: 'Michelle',
            actionLabel: 'New Contract',
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: _DashboardPageState._summaryCards
                .map((card) => _SummaryCard(card: card))
                .toList(),
          ),
          const SizedBox(height: 20),
          isCompact
              ? const Column(
                  children: [
                    _ProgressPanel(),
                    SizedBox(height: 16),
                    _StatusPanel(),
                  ],
                )
              : const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _ProgressPanel()),
                    SizedBox(width: 16),
                    Expanded(flex: 4, child: _StatusPanel()),
                  ],
                ),
        ],
      ),
    );
  }
}

class _CustomerWorkspace extends StatelessWidget {
  const _CustomerWorkspace();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopHeader(
            title: 'Customer',
            emphasis: 'Management',
            actionLabel: 'Add Customer',
          ),
          const SizedBox(height: 20),
          _Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeading(
                  title: 'Customer Register',
                  subtitle:
                      'Register customers and keep commercial records ready before contract creation.',
                ),
                const SizedBox(height: 18),
                _SimpleSearchBar(hint: 'Search customer...'),
                const SizedBox(height: 18),
                _DataTableCard(
                  columns: const ['Customer ID', 'Company', 'PIC', 'Status'],
                  rows: _DashboardPageState._customers
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

class _ContractListWorkspace extends StatelessWidget {
  const _ContractListWorkspace();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 1180;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopHeader(
            title: 'Contract',
            emphasis: 'Workspace',
            actionLabel: 'New Contract',
          ),
          const SizedBox(height: 20),
          isCompact
              ? const Column(
                  children: [
                    _ContractListPanel(),
                    SizedBox(height: 16),
                    _ContractDetailPanel(),
                  ],
                )
              : const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _ContractListPanel()),
                    SizedBox(width: 16),
                    Expanded(flex: 4, child: _ContractDetailPanel()),
                  ],
                ),
        ],
      ),
    );
  }
}

class _PaymentWorkspace extends StatelessWidget {
  const _PaymentWorkspace();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _TopHeader(
            title: 'Payment',
            emphasis: 'Progress',
            actionLabel: 'Record Payment',
          ),
          SizedBox(height: 20),
          _PaymentPanel(),
        ],
      ),
    );
  }
}

class _PlaceholderWorkspace extends StatelessWidget {
  const _PlaceholderWorkspace({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: _Panel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text(description, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 18),
              Text(
                'This module is ready for the next implementation pass in the same ERP shell.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContractListPanel extends StatelessWidget {
  const _ContractListPanel();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Contract List',
            subtitle: 'View and manage all interior project contracts.',
          ),
          const SizedBox(height: 16),
          const _SimpleSearchBar(hint: 'Search contract...'),
          const SizedBox(height: 18),
          _DataTableCard(
            columns: const [
              'Contract No.',
              'Customer',
              'Project / Title',
              'Value',
              'Status',
            ],
            rows: _DashboardPageState._contracts
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

class _ContractDetailPanel extends StatelessWidget {
  const _ContractDetailPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Panel(
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
          const _SectionHeading(
            title: 'Contract Detail',
            subtitle: 'FI-2026-001',
          ),
          const SizedBox(height: 18),
          const _KeyValueGrid(
            entries: [
              _KeyValue('Contract No.', 'FI-2026-001'),
              _KeyValue('Status', 'Active'),
              _KeyValue('Customer', 'PT Nirwana Kharisma'),
              _KeyValue('Project / Title', 'Luxury Apartment'),
              _KeyValue('Effective Date', '01 May 2026'),
              _KeyValue('End Date', '01 May 2027'),
              _KeyValue('Contract Value', 'Rp 1,250,000,000'),
              _KeyValue('Contract File', 'contract_fi_2026_001.pdf'),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'Assigned Staff & Commission',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _DataTableCard(
            columns: const [
              'Staff Name',
              'Department',
              'Commission (%)',
              'Commission Amount',
            ],
            rows: const [
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

class _PaymentPanel extends StatelessWidget {
  const _PaymentPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeading(
            title: 'Payment Progress',
            subtitle: 'Contract No. FI-2026-001',
          ),
          const SizedBox(height: 18),
          _DataTableCard(
            columns: const ['Stage', 'Due Date', 'Amount', 'Status'],
            rows: _DashboardPageState._payments
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
          const _LegendRow(
            label: 'Paid',
            value: 'Rp 750,000,000 (66%)',
            color: AppColors.success,
          ),
          const SizedBox(height: 10),
          const _LegendRow(
            label: 'Pending',
            value: 'Rp 375,000,000 (24%)',
            color: AppColors.warning,
          ),
          const SizedBox(height: 10),
          const _LegendRow(
            label: 'Overdue',
            value: 'Rp 0 (10%)',
            color: AppColors.danger,
          ),
        ],
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({
    required this.title,
    required this.emphasis,
    required this.actionLabel,
  });

  final String title;
  final String emphasis;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(emphasis, style: theme.textTheme.headlineMedium),
            ],
          ),
        ),
        if (MediaQuery.sizeOf(context).width >= 760) ...[
          FilledButton(onPressed: () {}, child: Text(actionLabel)),
        ],
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium?.copyWith(fontSize: 22)),
        const SizedBox(height: 6),
        Text(subtitle, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.card});

  final _SummaryCardData card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 180,
      child: _Panel(
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

class _ProgressPanel extends StatelessWidget {
  const _ProgressPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Panel(
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
                    _LegendRow(
                      label: 'Paid',
                      value: '66%',
                      color: AppColors.success,
                    ),
                    SizedBox(height: 12),
                    _LegendRow(
                      label: 'Pending',
                      value: '24%',
                      color: AppColors.warning,
                    ),
                    SizedBox(height: 12),
                    _LegendRow(
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

class _StatusPanel extends StatelessWidget {
  const _StatusPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Contract Status', style: theme.textTheme.titleMedium),
          const SizedBox(height: 18),
          const _StatusLine(label: 'Active', value: '28'),
          const SizedBox(height: 12),
          const _StatusLine(label: 'Pending', value: '10'),
          const SizedBox(height: 12),
          const _StatusLine(label: 'Completed', value: '5'),
          const SizedBox(height: 12),
          const _StatusLine(label: 'Cancelled', value: '0'),
        ],
      ),
    );
  }
}

class _SimpleSearchBar extends StatelessWidget {
  const _SimpleSearchBar({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }
}

class _DataTableCard extends StatelessWidget {
  const _DataTableCard({
    required this.columns,
    required this.rows,
    this.statusColumn,
  });

  final List<String> columns;
  final List<List<String>> rows;
  final int? statusColumn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
          dataTextStyle: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.ink,
          ),
          columns: columns
              .map((column) => DataColumn(label: Text(column)))
              .toList(),
          rows: rows
              .map(
                (row) => DataRow(
                  cells: row.asMap().entries.map((entry) {
                    final index = entry.key;
                    final value = entry.value;

                    if (statusColumn == index) {
                      return DataCell(_StatusBadge(value: value));
                    }
                    return DataCell(Text(value));
                  }).toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final color = switch (value) {
      'Active' => AppColors.success,
      'Paid' => AppColors.success,
      'Completed' => AppColors.success,
      'Pending' => AppColors.warning,
      'Prospect' => AppColors.warning,
      'Onboarding' => AppColors.secondary,
      _ => AppColors.secondary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}

class _KeyValueGrid extends StatelessWidget {
  const _KeyValueGrid({required this.entries});

  final List<_KeyValue> entries;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final columns = size.width >= 900 ? 2 : 1;

    return GridView.builder(
      itemCount: entries.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3.2,
      ),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceTint,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                entry.label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 6),
              Text(entry.value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        );
      },
    );
  }
}

class _MenuItem {
  const _MenuItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _SummaryCardData {
  const _SummaryCardData(this.label, this.value);

  final String label;
  final String value;
}

class _ContractRow {
  const _ContractRow({
    required this.contractNo,
    required this.customer,
    required this.project,
    required this.value,
    required this.status,
  });

  final String contractNo;
  final String customer;
  final String project;
  final String value;
  final String status;
}

class _PaymentRow {
  const _PaymentRow(this.stage, this.dueDate, this.amount, this.status);

  final String stage;
  final String dueDate;
  final String amount;
  final String status;
}

class _CustomerRow {
  const _CustomerRow(this.id, this.company, this.pic, this.status);

  final String id;
  final String company;
  final String pic;
  final String status;
}

class _KeyValue {
  const _KeyValue(this.label, this.value);

  final String label;
  final String value;
}
