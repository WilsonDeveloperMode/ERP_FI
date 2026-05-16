import 'package:flutter/material.dart';

class CustomerFormCard extends StatelessWidget {
  const CustomerFormCard({
    required this.formKey,
    required this.companyNameController,
    required this.contactPersonController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.onSubmit,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController companyNameController;
  final TextEditingController contactPersonController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2D5C8)),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New customer registration',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF4B3528),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create and maintain customer data for upcoming contracts.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF7A6557),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: companyNameController,
              decoration: const InputDecoration(
                labelText: 'Company name',
                hintText: 'Francis Interior Ltd',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Company name is required.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: contactPersonController,
              decoration: const InputDecoration(
                labelText: 'Contact person',
                hintText: 'Jane Doe',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Contact person is required.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'jane@company.com',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required.';
                }
                if (!value.contains('@')) {
                  return 'Enter a valid email.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: '+44 7000 000000',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Phone is required.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Customer site or office address',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Address is required.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF4B3528),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  'Save customer',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
