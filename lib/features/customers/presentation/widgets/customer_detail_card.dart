import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../domain/models/customer.dart';

class CustomerDetailCard extends StatelessWidget {
  const CustomerDetailCard({required this.customer, super.key});

  final Customer? customer;

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
      child: customer == null
          ? Center(
              child: Text(
                'Select a customer to view details.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer details',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 20),
                _DetailRow(label: 'Company', value: customer!.companyName),
                _DetailRow(
                  label: 'Contact person',
                  value: customer!.contactPerson,
                ),
                _DetailRow(label: 'Email', value: customer!.email),
                _DetailRow(label: 'Phone', value: customer!.phone),
                _DetailRow(label: 'Address', value: customer!.address),
                _DetailRow(
                  label: 'Customer ID',
                  value: customer!.id,
                  isLast: true,
                ),
              ],
            ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}
