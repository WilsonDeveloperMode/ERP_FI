import 'package:flutter/material.dart';

import 'package:erp_fi/customers/data/country_phone_options.dart';
import 'package:erp_fi/customers/data/customer_repository.dart';
import 'package:erp_fi/customers/pages/customer_detail_page.dart';
import 'package:erp_fi/customers/models/customer.dart';
import 'package:erp_fi/erp_shell/widgets/erp_simple_search_bar.dart';
import 'package:erp_fi/theme/app_colors.dart';
import '../widgets/customer_form_card.dart';
import '../widgets/customer_list_card.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage>
    with SingleTickerProviderStateMixin {
  final _repository = CustomerRepository();
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _primaryAddressController = TextEditingController();
  final _secondaryAddressController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedStatus = 'Active';
  CountryPhoneOption _selectedCountryPhone = defaultCountryPhoneOption;

  final List<Customer> _customers = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  late final AnimationController _loadingController;

  @override
  void dispose() {
    _loadingController.dispose();
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
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
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
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceTint,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            '${_customers.length} customer records',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          onPressed: _openNewCustomerDialog,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('New customer'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.border),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 24,
                              offset: Offset(0, 16),
                            ),
                          ],
                        ),
                        child: _buildCustomerListBody(),
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

  Widget _buildCustomerListBody() {
    if (_isLoading) {
      return _CustomerListLoadingState(animation: _loadingController);
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loadCustomers,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final filteredCustomers = _customers.where((customer) {
      if (_searchQuery.isEmpty) {
        return true;
      }

      final query = _searchQuery.toLowerCase();
      return customer.fullName.toLowerCase().contains(query) ||
          customer.contactNumber.toLowerCase().contains(query) ||
          customer.primaryAddress.toLowerCase().contains(query);
    }).toList();

    return CustomerListCard(
      customers: filteredCustomers,
      onSelected: _openCustomerDetail,
      selectedCustomerId: null,
      searchBar: ErpSimpleSearchBar(
        hint: 'Search by customer, phone, or address',
        controller: _searchController,
        onChanged: _updateSearchQuery,
      ),
    );
  }

  Future<void> _openNewCustomerDialog() async {
    _resetCustomerForm();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760, maxHeight: 760),
            child: CustomerFormCard(
              formKey: _formKey,
              fullNameController: _fullNameController,
              contactPersonController: _contactPersonController,
              emailController: _emailController,
              contactNumberController: _contactNumberController,
              primaryAddressController: _primaryAddressController,
              secondaryAddressController: _secondaryAddressController,
              notesController: _notesController,
              selectedCountryPhone: _selectedCountryPhone,
              onCountryPhoneChanged: _updateCountryPhone,
              selectedStatus: _selectedStatus,
              onStatusChanged: _updateStatus,
              onSubmit: () => _saveCustomer(dialogContext),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveCustomer(BuildContext dialogContext) async {
    if (!_formKey.currentState!.validate()) {
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
      status: _selectedStatus,
      addresses: addresses,
      notes: _notesController.text.trim(),
      createdAt: DateTime.now(),
    );

    try {
      final customer = await _repository.createCustomer(draftCustomer);

      if (!mounted) {
        return;
      }

      setState(() {
        _customers.insert(0, customer);
      });

      if (!dialogContext.mounted) {
        return;
      }

      Navigator.of(dialogContext).pop();
      _resetCustomerForm();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          content: Text('${customer.fullName} added successfully.'),
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
          content: Text('Failed to save customer to Supabase.'),
        ),
      );
    }
  }

  void _resetCustomerForm() {
    _formKey.currentState?.reset();
    _fullNameController.clear();
    _contactPersonController.clear();
    _emailController.clear();
    _contactNumberController.clear();
    _primaryAddressController.clear();
    _secondaryAddressController.clear();
    _notesController.clear();
    _selectedStatus = 'Active';
    _selectedCountryPhone = defaultCountryPhoneOption;
  }

  void _openCustomerDetail(Customer customer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CustomerDetailPage(
          customer: customer,
          onCustomerUpdated: _updateCustomer,
          repository: _repository,
        ),
      ),
    );
  }

  void _updateCustomer(Customer updatedCustomer) {
    final index = _customers.indexWhere((customer) => customer.id == updatedCustomer.id);
    if (index == -1) {
      return;
    }

    setState(() {
      _customers[index] = updatedCustomer;
    });
  }

  void _updateStatus(String? status) {
    if (status == null) {
      return;
    }

    setState(() {
      _selectedStatus = status;
    });
  }

  void _updateCountryPhone(CountryPhoneOption countryPhone) {
    setState(() {
      _selectedCountryPhone = countryPhone;
    });
  }

  void _updateSearchQuery(String value) {
    setState(() {
      _searchQuery = value.trim();
    });
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final customers = await _repository.fetchCustomers();
      if (!mounted) {
        return;
      }

      setState(() {
        _customers
          ..clear()
          ..addAll(customers);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Could not load customers from Supabase. Check the table setup and policies.';
      });
    }
  }
}

class _CustomerListLoadingState extends StatelessWidget {
  const _CustomerListLoadingState({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final opacity = 0.45 + (animation.value * 0.35);

        return Column(
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
              'Loading customers from Supabase...',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.surfaceTint.withValues(alpha: opacity),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCFAF7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceTint.withValues(
                                    alpha: opacity,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 68,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.glaze.withValues(alpha: opacity),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 16,
                          width: 220,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceTint.withValues(alpha: opacity),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceTint.withValues(alpha: opacity),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
