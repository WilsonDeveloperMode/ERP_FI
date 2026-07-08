import 'package:flutter/material.dart';

import 'package:erp_fi/contracts/data/contract_repository.dart';
import 'package:erp_fi/contracts/models/contract_record.dart';
import 'package:erp_fi/contracts/pages/contract_detail_page.dart';
import 'package:erp_fi/contracts/widgets/contract_form_dialog.dart';
import 'package:erp_fi/contracts/widgets/contract_list_panel.dart';
import 'package:erp_fi/customers/data/country_phone_options.dart';
import 'package:erp_fi/customers/data/customer_repository.dart';
import 'package:erp_fi/customers/models/customer.dart';
import 'package:erp_fi/customers/widgets/customer_form_card.dart';
import 'package:erp_fi/erp_shell/widgets/erp_top_header.dart';
import 'package:erp_fi/theme/app_colors.dart';

class ContractWorkspacePage extends StatefulWidget {
  const ContractWorkspacePage({super.key});

  @override
  State<ContractWorkspacePage> createState() => _ContractWorkspacePageState();
}

class _ContractWorkspacePageState extends State<ContractWorkspacePage> {
  final _contractRepository = ContractRepository();
  final _customerRepository = CustomerRepository();
  final _searchController = TextEditingController();
  final _customerFormKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _primaryAddressController = TextEditingController();
  final _secondaryAddressController = TextEditingController();
  final _notesController = TextEditingController();

  final List<ContractRecord> _contracts = [];
  final List<Customer> _customers = [];

  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCustomerStatus = 'Active';
  CountryPhoneOption _selectedCountryPhone = defaultCountryPhoneOption;

  @override
  void initState() {
    super.initState();
    _loadWorkspace();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fullNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    _primaryAddressController.dispose();
    _secondaryAddressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loadWorkspace,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final filteredContracts = _filteredContracts();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ErpTopHeader(
            title: 'Contract',
            emphasis: 'Records',
            actionLabel: 'New Contract',
            onActionPressed: _openCreateContractDialog,
          ),
          const SizedBox(height: 20),
          ContractListPanel(
            contracts: filteredContracts,
            onOpen: _openContractDetail,
            searchController: _searchController,
            onSearchChanged: _updateSearchQuery,
          ),
        ],
      ),
    );
  }

  List<ContractRecord> _filteredContracts() {
    if (_searchQuery.isEmpty) {
      return List<ContractRecord>.from(_contracts);
    }

    final query = _searchQuery.toLowerCase();
    return _contracts.where((contract) {
      return contract.contractNumber.toLowerCase().contains(query) ||
          contract.customerName.toLowerCase().contains(query) ||
          contract.projectTitle.toLowerCase().contains(query) ||
          contract.subject.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _loadWorkspace() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _customerRepository.fetchCustomers(),
        _contractRepository.fetchContracts(),
      ]);

      if (!mounted) {
        return;
      }

      final customers = results[0] as List<Customer>;
      final contracts = results[1] as List<ContractRecord>;

      setState(() {
        _customers
          ..clear()
          ..addAll(customers);
        _contracts
          ..clear()
          ..addAll(contracts);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Could not load contracts. Make sure both customer and contract tables are created in Supabase.';
      });
    }
  }

  Future<void> _openCreateContractDialog() async {
    final contract = await showDialog<ContractRecord>(
      context: context,
      builder: (context) => ContractFormDialog(
        customers: _customers,
        initialContractNumber: _nextContractNumber(),
        onCreateCustomer: _openQuickCustomerDialog,
      ),
    );

    if (contract == null) {
      return;
    }

    try {
      final savedContract = await _contractRepository.createContract(contract);

      if (!mounted) {
        return;
      }

      setState(() {
        _contracts.insert(0, savedContract);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          content: Text('${savedContract.contractNumber} saved successfully.'),
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
          content: Text(
            'Failed to save contract. Check the contracts table and contract number uniqueness.',
          ),
        ),
      );
    }
  }

  void _openContractDetail(ContractRecord contract) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ContractDetailPage(
          contract: contract,
          customers: _customers,
          repository: _contractRepository,
          onContractUpdated: _updateContract,
          onCreateCustomer: _openQuickCustomerDialog,
        ),
      ),
    );
  }

  String _nextContractNumber() {
    final year = DateTime.now().year;
    final sequence = (_contracts.length + 1).toString().padLeft(3, '0');
    return 'FI-$year-$sequence';
  }

  void _updateSearchQuery(String value) {
    setState(() {
      _searchQuery = value.trim();
    });
  }

  void _updateContract(ContractRecord updatedContract) {
    final index = _contracts.indexWhere(
      (contract) => contract.id == updatedContract.id,
    );
    if (index == -1) {
      return;
    }

    setState(() {
      _contracts[index] = updatedContract;
    });
  }

  Future<Customer?> _openQuickCustomerDialog() async {
    _resetCustomerForm();

    return showDialog<Customer>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760, maxHeight: 760),
            child: CustomerFormCard(
              formKey: _customerFormKey,
              title: 'Quick new customer',
              subtitle:
                  'Add the customer here, then continue building the contract without leaving this workflow.',
              submitLabel: 'Save customer',
              fullNameController: _fullNameController,
              contactPersonController: _contactPersonController,
              emailController: _emailController,
              contactNumberController: _contactNumberController,
              primaryAddressController: _primaryAddressController,
              secondaryAddressController: _secondaryAddressController,
              notesController: _notesController,
              selectedCountryPhone: _selectedCountryPhone,
              onCountryPhoneChanged: _updateCountryPhone,
              selectedStatus: _selectedCustomerStatus,
              onStatusChanged: _updateCustomerStatus,
              onSubmit: () => _saveQuickCustomer(dialogContext),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveQuickCustomer(BuildContext dialogContext) async {
    if (!_customerFormKey.currentState!.validate()) {
      return;
    }

    final addresses = [
      _primaryAddressController.text.trim(),
      _secondaryAddressController.text.trim(),
    ].where((address) => address.isNotEmpty).toList();

    final draftCustomer = Customer(
      id: '',
      fullName: _fullNameController.text.trim(),
      contactPerson: _contactPersonController.text.trim().isEmpty
          ? null
          : _contactPersonController.text.trim(),
      email: _emailController.text.trim(),
      contactNumber:
          '${_selectedCountryPhone.dialCode} ${_contactNumberController.text.trim()}',
      status: _selectedCustomerStatus,
      addresses: addresses,
      notes: _notesController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      final customer = await _customerRepository.createCustomer(draftCustomer);

      if (!mounted || !dialogContext.mounted) {
        return;
      }

      setState(() {
        _customers.insert(0, customer);
      });

      Navigator.of(dialogContext).pop(customer);
      _resetCustomerForm();
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.danger,
          content: Text('Failed to save customer to Supabase.'),
        ),
      );
    }

  }

  void _resetCustomerForm() {
    _customerFormKey.currentState?.reset();
    _fullNameController.clear();
    _contactPersonController.clear();
    _emailController.clear();
    _contactNumberController.clear();
    _primaryAddressController.clear();
    _secondaryAddressController.clear();
    _notesController.clear();
    _selectedCustomerStatus = 'Active';
    _selectedCountryPhone = defaultCountryPhoneOption;
  }

  void _updateCountryPhone(CountryPhoneOption value) {
    setState(() {
      _selectedCountryPhone = value;
    });
  }

  void _updateCustomerStatus(String? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _selectedCustomerStatus = value;
    });
  }
}
