import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:erp_fi/contracts/models/contract_record.dart';
import 'package:erp_fi/erp_shell/models/erp_record_models.dart';
import 'package:erp_fi/erp_shell/widgets/erp_key_value_grid.dart';
import 'package:erp_fi/erp_shell/widgets/erp_panel.dart';
import 'package:erp_fi/erp_shell/widgets/erp_section_heading.dart';
import 'package:erp_fi/erp_shell/widgets/erp_status_badge.dart';
import 'package:erp_fi/theme/app_colors.dart';

class ContractDetailPanel extends StatelessWidget {
  ContractDetailPanel({required this.contract, super.key})
    : _currencyFormat = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0,
      );

  final ContractRecord? contract;
  final NumberFormat _currencyFormat;

  @override
  Widget build(BuildContext context) {
    if (contract == null) {
      return ErpPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ErpSectionHeading(
              title: 'Contract Detail',
              subtitle: 'Select a contract to review its offer structure.',
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.canvas,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'No contract selected yet. Pick one from the list or create a new contract from a customer.',
              ),
            ),
          ],
        ),
      );
    }

    final selectedContract = contract!;

    return ErpPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ErpSectionHeading(
                  title: selectedContract.subject,
                  subtitle: selectedContract.contractNumber,
                ),
              ),
              ErpStatusBadge(value: selectedContract.status),
            ],
          ),
          const SizedBox(height: 18),
          ErpKeyValueGrid(entries: _buildSummaryEntries(selectedContract)),
          const SizedBox(height: 20),
          _DetailCard(
            title: 'Intro',
            child: Text(
              selectedContract.introMessage.isEmpty
                  ? 'No opening paragraph added.'
                  : selectedContract.introMessage,
            ),
          ),
          const SizedBox(height: 16),
          _DetailCard(
            title: 'Recipient',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedContract.recipientName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(selectedContract.recipientAddress),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DetailCard(
            title: 'Scope of Work',
            child: Column(
              children: selectedContract.sections
                  .map((section) => _SectionBlock(section: section))
                  .toList(),
            ),
          ),
          const SizedBox(height: 16),
          _DetailCard(
            title: 'Material Details',
            child: Text(
              selectedContract.materialDetails.isEmpty
                  ? 'No material details added.'
                  : selectedContract.materialDetails,
            ),
          ),
          const SizedBox(height: 16),
          _DetailCard(
            title: 'Closing Notes',
            child: Text(
              selectedContract.closingNotes.isEmpty
                  ? 'No closing notes added.'
                  : selectedContract.closingNotes,
            ),
          ),
        ],
      ),
    );
  }

  List<KeyValueEntry> _buildSummaryEntries(ContractRecord contract) {
    return [
      KeyValueEntry('Customer', contract.customerName),
      KeyValueEntry('Project / Title', contract.projectTitle),
      KeyValueEntry(
        'Contract Date',
        DateFormat('dd MMMM yyyy').format(contract.contractDate),
      ),
      KeyValueEntry('City', contract.city),
      KeyValueEntry('Total', _currencyFormat.format(contract.totalAmount)),
      KeyValueEntry('Sections', '${contract.sections.length}'),
    ];
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({required this.section});

  final ContractSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ...section.lineItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.circle,
                      size: 7,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ),
          if (section.finish.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Finish / Option: ${section.finish}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (section.sectionNotes.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              section.sectionNotes,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
}
