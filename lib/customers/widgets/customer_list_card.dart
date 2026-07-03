import 'package:flutter/material.dart';
import 'package:erp_fi/customers/models/customer.dart';
import 'package:erp_fi/theme/app_colors.dart';

class CustomerListCard extends StatelessWidget {
  const CustomerListCard({
    required this.customers,
    required this.onSelected,
    required this.selectedCustomerId,
    this.searchBar,
    super.key,
  });

  final List<Customer> customers;
  final ValueChanged<Customer> onSelected;
  final String? selectedCustomerId;
  final Widget? searchBar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer register',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${customers.length} customers available for contracts and payment staging.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          if (searchBar != null) ...[
            searchBar!,
            const SizedBox(height: 18),
          ],
          if (customers.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No customers yet.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: customers.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  final isSelected = customer.id == selectedCustomerId;

                  return Material(
                    color: isSelected
                        ? AppColors.glaze
                        : const Color(0xFFFCFAF7),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () => onSelected(customer),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    customer.fullName,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: AppColors.ink,
                                        ),
                                  ),
                                ),
                                _StatusChip(status: customer.status),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              customer.contactNumber,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              customer.primaryAddress,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = switch (status) {
      'Active' => AppColors.success,
      'Lead' => AppColors.warning,
      _ => AppColors.textSecondary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelLarge?.copyWith(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }
}
