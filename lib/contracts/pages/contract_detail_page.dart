import 'package:flutter/material.dart';

import 'package:erp_fi/contracts/data/contract_repository.dart';
import 'package:erp_fi/contracts/models/contract_record.dart';
import 'package:erp_fi/contracts/widgets/contract_detail_panel.dart';
import 'package:erp_fi/contracts/widgets/contract_form_dialog.dart';
import 'package:erp_fi/customers/models/customer.dart';
import 'package:erp_fi/theme/app_colors.dart';

class ContractDetailPage extends StatefulWidget {
  const ContractDetailPage({
    required this.contract,
    required this.customers,
    required this.repository,
    required this.onContractUpdated,
    required this.onCreateCustomer,
    super.key,
  });

  final ContractRecord contract;
  final List<Customer> customers;
  final ContractRepository repository;
  final ValueChanged<ContractRecord> onContractUpdated;
  final Future<Customer?> Function() onCreateCustomer;

  @override
  State<ContractDetailPage> createState() => _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  late ContractRecord _contract = widget.contract;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.heroTop, AppColors.canvas],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _contract.subject,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _contract.contractNumber,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: _openEditDialog,
                          icon: const Icon(Icons.edit_rounded),
                          label: const Text('Edit contract'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ContractDetailPanel(contract: _contract),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openEditDialog() async {
    final updatedContract = await showDialog<ContractRecord>(
      context: context,
      builder: (context) => ContractFormDialog(
        customers: widget.customers,
        initialContractNumber: _contract.contractNumber,
        initialContract: _contract,
        onCreateCustomer: widget.onCreateCustomer,
      ),
    );

    if (updatedContract == null) {
      return;
    }

    try {
      final savedContract = await widget.repository.updateContract(
        updatedContract,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _contract = savedContract;
      });

      widget.onContractUpdated(savedContract);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          content: Text('Contract updated successfully.'),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.danger,
          content: Text('Failed to update contract in Supabase.'),
        ),
      );
    }
  }
}
