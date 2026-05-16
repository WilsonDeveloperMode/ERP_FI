import 'package:flutter/material.dart';

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
      companyName: 'Apex Living',
      contactPerson: 'Emma Reed',
      email: 'emma@apexliving.com',
      phone: '+44 7712 221100',
      address: '18 Rose Avenue, London',
      createdAt: DateTime(2026, 5, 2),
    ),
    Customer(
      id: 'CUS-002',
      companyName: 'Northfield Suites',
      contactPerson: 'Michael Hart',
      email: 'michael@northfield.com',
      phone: '+44 7810 102030',
      address: '24 Hill Street, Manchester',
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
    final isCompact = MediaQuery.sizeOf(context).width < 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F0E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Customer Management',
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFF4B3528),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workflow Step 1: Customer',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontSize: 42,
                    color: const Color(0xFF4B3528),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Register customers and maintain the core details required before contract creation.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6E5948),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: isCompact
                      ? ListView(
                          children: [
                            CustomerFormCard(
                              formKey: _formKey,
                              companyNameController: _companyNameController,
                              contactPersonController: _contactPersonController,
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
                                companyNameController: _companyNameController,
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
              ],
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
