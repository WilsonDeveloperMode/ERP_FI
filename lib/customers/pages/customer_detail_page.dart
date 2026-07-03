import 'package:flutter/material.dart';

import 'package:erp_fi/customers/data/country_phone_options.dart';
import 'package:erp_fi/customers/data/customer_repository.dart';
import 'package:erp_fi/customers/models/customer.dart';
import 'package:erp_fi/customers/widgets/customer_detail_card.dart';
import 'package:erp_fi/customers/widgets/customer_form_card.dart';
import 'package:erp_fi/theme/app_colors.dart';

class CustomerDetailPage extends StatefulWidget {
  const CustomerDetailPage({
    required this.customer,
    required this.onCustomerUpdated,
    required this.repository,
    super.key,
  });

  final Customer customer;
  final ValueChanged<Customer> onCustomerUpdated;
  final CustomerRepository repository;

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  late Customer _customer = widget.customer;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _primaryAddressController = TextEditingController();
  final _secondaryAddressController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedStatus = 'Active';
  CountryPhoneOption _selectedCountryPhone = defaultCountryPhoneOption;

  @override
  void dispose() {
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
                                _customer.fullName,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Customer details',
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
                          label: const Text('Edit customer'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(child: CustomerDetailCard(customer: _customer)),
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
    _seedFormFromCustomer(_customer);

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
              onSubmit: () => _saveCustomerEdit(dialogContext),
              title: 'Edit customer',
              subtitle:
                  'Update contact information, address details, and operating status.',
              submitLabel: 'Save changes',
            ),
          ),
        );
      },
    );
  }

  void _seedFormFromCustomer(Customer customer) {
    _formKey.currentState?.reset();
    final phoneParts = splitPhoneNumber(customer.contactNumber);
    _fullNameController.text = customer.fullName;
    _contactPersonController.text = customer.contactPerson ?? '';
    _emailController.text = customer.email;
    _contactNumberController.text = phoneParts.localNumber;
    _primaryAddressController.text =
        customer.addresses.isNotEmpty ? customer.addresses.first : '';
    _secondaryAddressController.text =
        customer.addresses.length > 1 ? customer.addresses[1] : '';
    _notesController.text = customer.notes;
    _selectedStatus = customer.status;
    _selectedCountryPhone = phoneParts.country;
  }

  Future<void> _saveCustomerEdit(BuildContext dialogContext) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final addresses = [
      _primaryAddressController.text.trim(),
      _secondaryAddressController.text.trim(),
    ].where((address) => address.isNotEmpty).toList();

    final updatedCustomer = Customer(
      id: _customer.id,
      fullName: _fullNameController.text.trim(),
      contactPerson: _contactPersonController.text.trim().isEmpty
          ? null
          : _contactPersonController.text.trim(),
      email: _emailController.text.trim(),
      contactNumber:
          '${_selectedCountryPhone.dialCode} ${_contactNumberController.text.trim()}',
      status: _selectedStatus,
      addresses: addresses,
      customerType: _customer.customerType,
      notes: _notesController.text.trim(),
      createdAt: _customer.createdAt,
    );

    try {
      final savedCustomer = await widget.repository.updateCustomer(updatedCustomer);
      if (!mounted) {
        return;
      }

      setState(() {
        _customer = savedCustomer;
      });

      widget.onCustomerUpdated(savedCustomer);

      if (!dialogContext.mounted) {
        return;
      }

      Navigator.of(dialogContext).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          content: Text('Customer updated successfully.'),
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
          content: Text('Failed to update customer in Supabase.'),
        ),
      );
    }
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
}
