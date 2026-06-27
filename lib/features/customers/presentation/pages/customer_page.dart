import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../domain/models/customer.dart';
import '../widgets/customer_detail_card.dart';
import '../widgets/customer_form_card.dart';
import '../widgets/customer_list_card.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  late final List<Customer> _customers = [
    Customer(
      id: 'CUS-001',
      companyName: 'PT Nirwana Kharisma',
      contactPerson: 'Michelle',
      email: 'michelle@nirwanakharisma.com',
      phone: '+62 811 2233 4411',
      address: 'Jl. Kemang Raya No. 18, Jakarta',
      createdAt: DateTime(2026, 5, 2),
    ),
    Customer(
      id: 'CUS-002',
      companyName: 'PT Golden Land',
      contactPerson: 'Kevin',
      email: 'kevin@goldenland.id',
      phone: '+62 812 9988 7766',
      address: 'Jl. Raya Uluwatu No. 6, Bali',
      createdAt: DateTime(2026, 5, 10),
    ),
  ];

  Customer? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    _selectedCustomer = _customers.first;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 1100;

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
                                'Customer Management',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Workflow Step 1 of the ERP. Register customer details before contract creation and payment staging.',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
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
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
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
                        child: isCompact
                            ? ListView(
                                children: [
                                  CustomerFormCard(
                                    formKey: _formKey,
                                    companyNameController:
                                        _companyNameController,
                                    contactPersonController:
                                        _contactPersonController,
                                    emailController: _emailController,
                                    phoneController: _phoneController,
                                    addressController: _addressController,
                                    onSubmit: _saveCustomer,
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    height: 360,
                                    child: CustomerListCard(
                                      customers: _customers,
                                      onSelected: _selectCustomer,
                                      selectedCustomerId: _selectedCustomer?.id,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    height: 320,
                                    child: CustomerDetailCard(
                                      customer: _selectedCustomer,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: CustomerFormCard(
                                      formKey: _formKey,
                                      companyNameController:
                                          _companyNameController,
                                      contactPersonController:
                                          _contactPersonController,
                                      emailController: _emailController,
                                      phoneController: _phoneController,
                                      addressController: _addressController,
                                      onSubmit: _saveCustomer,
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    flex: 3,
                                    child: CustomerListCard(
                                      customers: _customers,
                                      onSelected: _selectCustomer,
                                      selectedCustomerId: _selectedCustomer?.id,
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    flex: 3,
                                    child: CustomerDetailCard(
                                      customer: _selectedCustomer,
                                    ),
                                  ),
                                ],
                              ),
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

  void _saveCustomer() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final customer = Customer(
      id: 'CUS-${(_customers.length + 1).toString().padLeft(3, '0')}',
      companyName: _companyNameController.text.trim(),
      contactPerson: _contactPersonController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      createdAt: DateTime.now(),
    );

    setState(() {
      _customers.insert(0, customer);
      _selectedCustomer = customer;
    });

    _companyNameController.clear();
    _contactPersonController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        content: Text('${customer.companyName} added successfully.'),
      ),
    );
  }

  void _selectCustomer(Customer customer) {
    setState(() {
      _selectedCustomer = customer;
    });
  }
}
