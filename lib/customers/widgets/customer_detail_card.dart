import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:erp_fi/customers/models/customer.dart';
import 'package:erp_fi/theme/app_colors.dart';

class CustomerDetailCard extends StatelessWidget {
  const CustomerDetailCard({required this.customer, super.key});

  final Customer? customer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy');

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
          : SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 720;
                  final infoWidth = wide
                      ? (constraints.maxWidth - 16) / 2
                      : constraints.maxWidth;
                  final sectionWidth = wide
                      ? (constraints.maxWidth - 20) / 2
                      : constraints.maxWidth;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.surfaceTint, AppColors.card],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'CUSTOMER DETAILS',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              color: AppColors.secondary,
                                              letterSpacing: 1.1,
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        customer!.fullName,
                                        style: theme.textTheme.headlineMedium
                                            ?.copyWith(color: AppColors.ink),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        customer!.primaryAddress,
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                _StatusBadge(status: customer!.status),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _InlineStat(
                                  label: 'Phone',
                                  value: customer!.contactNumber,
                                ),
                                _InlineStat(
                                  label: 'Registered',
                                  value: dateFormat.format(customer!.createdAt),
                                ),
                                if (customer!.email.isNotEmpty)
                                  _InlineStat(
                                    label: 'Email',
                                    value: customer!.email,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _SectionCard(
                            width: sectionWidth,
                            title: 'Main Information',
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                _InfoTile(
                                  width: infoWidth > sectionWidth
                                      ? sectionWidth
                                      : (sectionWidth - 16) / 2,
                                  label: 'Contact number',
                                  value: customer!.contactNumber,
                                ),
                                _InfoTile(
                                  width: infoWidth > sectionWidth
                                      ? sectionWidth
                                      : (sectionWidth - 16) / 2,
                                  label: 'Primary address',
                                  value: customer!.primaryAddress,
                                ),
                                _InfoTile(
                                  width: infoWidth > sectionWidth
                                      ? sectionWidth
                                      : (sectionWidth - 16) / 2,
                                  label: 'Contact person',
                                  value: customer!.contactPerson ?? '-',
                                ),
                                _InfoTile(
                                  width: infoWidth > sectionWidth
                                      ? sectionWidth
                                      : (sectionWidth - 16) / 2,
                                  label: 'Email',
                                  value: customer!.email.isEmpty
                                      ? '-'
                                      : customer!.email,
                                ),
                              ],
                            ),
                          ),
                          _SectionCard(
                            width: sectionWidth,
                            title: 'Addresses',
                            child: Column(
                              children: customer!.addresses.asMap().entries.map((
                                entry,
                              ) {
                                final isLast =
                                    entry.key == customer!.addresses.length - 1;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: isLast ? 0 : 12,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: entry.key == 0
                                          ? AppColors.glaze
                                          : AppColors.surfaceTint,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entry.key == 0
                                              ? 'Primary address'
                                              : 'Additional address ${entry.key}',
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                                color: AppColors.secondary,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          entry.value,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                                color: AppColors.textPrimary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          _SectionCard(
                            width: constraints.maxWidth,
                            title: 'Notes',
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceTint,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(
                                customer!.notes.isEmpty ? '-' : customer!.notes,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.width,
    required this.title,
    required this.child,
  });

  final double width;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.ink,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.width,
    required this.label,
    required this.value,
  });

  final double width;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.secondary,
              fontSize: 12,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}

class _InlineStat extends StatelessWidget {
  const _InlineStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyMedium,
          children: [
            TextSpan(
              text: '$label: ',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.secondary,
              ),
            ),
            TextSpan(
              text: value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelLarge?.copyWith(color: color, fontSize: 12),
      ),
    );
  }
}
