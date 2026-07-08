import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:erp_fi/contracts/models/contract_record.dart';
import 'package:erp_fi/erp_shell/widgets/erp_panel.dart';
import 'package:erp_fi/erp_shell/widgets/erp_section_heading.dart';
import 'package:erp_fi/erp_shell/widgets/erp_simple_search_bar.dart';
import 'package:erp_fi/erp_shell/widgets/erp_status_badge.dart';
import 'package:erp_fi/theme/app_colors.dart';

class ContractListPanel extends StatelessWidget {
  ContractListPanel({
    required this.contracts,
    required this.onOpen,
    required this.searchController,
    required this.onSearchChanged,
    super.key,
  }) : _currencyFormat = NumberFormat.currency(
         locale: 'id_ID',
         symbol: 'Rp ',
         decimalDigits: 0,
       );

  final List<ContractRecord> contracts;
  final ValueChanged<ContractRecord> onOpen;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final NumberFormat _currencyFormat;

  @override
  Widget build(BuildContext context) {
    return ErpPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ErpSectionHeading(
            title: 'Contract List',
            subtitle:
                '${contracts.length} customer-linked contracts ready for pricing, material details, and payment staging.',
          ),
          const SizedBox(height: 16),
          ErpSimpleSearchBar(
            hint: 'Search by contract, customer, or project',
            controller: searchController,
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 18),
          if (contracts.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.canvas,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'No contracts yet. Create the first contract from an existing customer record.',
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contracts.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final contract = contracts[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => onOpen(contract),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.canvas,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                contract.contractNumber,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: AppColors.ink),
                              ),
                            ),
                            ErpStatusBadge(value: contract.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          contract.customerName,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          contract.projectTitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _MetaChip(
                              label: 'Date',
                              value: _dateLabel(contract),
                            ),
                            _MetaChip(
                              label: 'Total',
                              value: _currencyFormat.format(
                                contract.totalAmount,
                              ),
                            ),
                            _MetaChip(
                              label: 'Sections',
                              value: '${contract.sections.length} areas',
                            ),
                            const _MetaChip(
                              label: 'Open',
                              value: 'View details',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String _dateLabel(ContractRecord contract) {
    return DateFormat('dd MMM yyyy').format(contract.contractDate);
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: RichText(
        text: TextSpan(
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
              text: value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
