import 'package:flutter/material.dart';

import '../../../customers/presentation/pages/customer_page.dart';
import '../widgets/dashboard_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompact = MediaQuery.sizeOf(context).width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F0E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Francis Interior ERP',
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFF4B3528),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontSize: 46,
                    color: const Color(0xFF4B3528),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Logged in locally as admin.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6E5948),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start building the workflow step by step from customer setup through contract delivery.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF8B7768),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: isCompact ? 1 : 3,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 1.35,
                    children: [
                      DashboardCard(
                        title: 'Customers',
                        value: '01',
                        icon: Icons.people_alt_rounded,
                        subtitle: 'Register and maintain customer records.',
                        onTap: () => _openPage(context, const CustomerPage()),
                      ),
                      DashboardCard(
                        title: 'Contracts',
                        value: '02',
                        icon: Icons.description_rounded,
                        subtitle: 'Next module: create and manage contracts.',
                      ),
                      DashboardCard(
                        title: 'Payments',
                        value: '06',
                        icon: Icons.receipt_long_rounded,
                        subtitle: 'Planned for split-stage payment tracking.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPage(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }
}
