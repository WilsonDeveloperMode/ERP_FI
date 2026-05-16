import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/customer.dart';

class CustomerListCard extends StatelessWidget {
  const CustomerListCard({
    required this.customers,
    required this.onSelected,
    required this.selectedCustomerId,
    super.key,
  });

  final List<Customer> customers;
  final ValueChanged<Customer> onSelected;
  final String? selectedCustomerId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2D5C8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer register',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF4B3528),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${customers.length} customers available for sales contracts.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF7A6557),
            ),
          ),
          const SizedBox(height: 20),
          if (customers.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'No customers yet.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF8B7768),
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
                        ? const Color(0xFFF4ECE3)
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
                            Text(
                              customer.companyName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF4B3528),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${customer.contactPerson} • ${customer.phone}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF7A6557),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Created ${dateFormat.format(customer.createdAt)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: const Color(0xFF9A8574),
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
