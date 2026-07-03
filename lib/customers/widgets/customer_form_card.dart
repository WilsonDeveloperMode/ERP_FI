import 'package:flutter/material.dart';

import 'package:erp_fi/customers/data/country_phone_options.dart';
import 'package:erp_fi/theme/app_colors.dart';

class CustomerFormCard extends StatefulWidget {
  const CustomerFormCard({
    required this.formKey,
    required this.fullNameController,
    required this.contactPersonController,
    required this.emailController,
    required this.contactNumberController,
    required this.primaryAddressController,
    required this.secondaryAddressController,
    required this.notesController,
    required this.selectedCountryPhone,
    required this.onCountryPhoneChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onSubmit,
    this.title = 'New customer registration',
    this.subtitle = '',
    this.submitLabel = 'Save customer',
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController contactPersonController;
  final TextEditingController emailController;
  final TextEditingController contactNumberController;
  final TextEditingController primaryAddressController;
  final TextEditingController secondaryAddressController;
  final TextEditingController notesController;
  final CountryPhoneOption selectedCountryPhone;
  final ValueChanged<CountryPhoneOption> onCountryPhoneChanged;
  final String selectedStatus;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onSubmit;
  final String title;
  final String subtitle;
  final String submitLabel;

  @override
  State<CustomerFormCard> createState() => _CustomerFormCardState();
}

class _CustomerFormCardState extends State<CustomerFormCard> {
  static const _statuses = ['Active', 'Lead', 'Inactive'];
  bool _showAdditionalAddress = false;

  @override
  void initState() {
    super.initState();
    _syncAdditionalAddressVisibility();
  }

  @override
  void didUpdateWidget(covariant CustomerFormCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAdditionalAddressVisibility();
  }

  void _syncAdditionalAddressVisibility() {
    final shouldShow =
        widget.secondaryAddressController.text.trim().isNotEmpty;
    if (shouldShow != _showAdditionalAddress) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _showAdditionalAddress = shouldShow;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.ink,
                ),
              ),
              if (widget.subtitle.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final twoColumn = constraints.maxWidth > 560;

                  Widget field(Widget child) {
                    if (!twoColumn) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: child,
                      );
                    }

                    return SizedBox(
                      width: (constraints.maxWidth - 16) / 2,
                      child: child,
                    );
                  }

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth,
                        child: TextFormField(
                          controller: widget.fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Full name',
                            hintText: 'Michelle Hartono',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Full name is required.';
                            }
                            return null;
                          },
                        ),
                      ),
                      field(
                        TextFormField(
                          controller: widget.contactPersonController,
                          decoration: const InputDecoration(
                            labelText: 'Contact person',
                            hintText: 'Optional if different from customer name',
                          ),
                        ),
                      ),
                      field(
                        DropdownButtonFormField<String>(
                          initialValue: widget.selectedStatus,
                          decoration: const InputDecoration(labelText: 'Status'),
                          items: _statuses
                              .map(
                                (status) => DropdownMenuItem<String>(
                                  value: status,
                                  child: Text(status),
                                ),
                              )
                              .toList(),
                          onChanged: widget.onStatusChanged,
                        ),
                      ),
                      field(
                        TextFormField(
                          controller: widget.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email (optional)',
                            hintText: 'customer@email.com',
                          ),
                          validator: (value) {
                            if (value != null &&
                                value.trim().isNotEmpty &&
                                !value.contains('@')) {
                              return 'Enter a valid email.';
                            }
                            return null;
                          },
                        ),
                      ),
                      field(
                        LayoutBuilder(
                          builder: (context, fieldConstraints) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: fieldConstraints.maxWidth * 0.32,
                                  child:
                                      DropdownButtonFormField<CountryPhoneOption>(
                                        initialValue: widget.selectedCountryPhone,
                                        isExpanded: true,
                                        menuMaxHeight: 360,
                                        decoration: const InputDecoration(
                                          labelText: 'Code',
                                        ),
                                        selectedItemBuilder: (context) {
                                          return countryPhoneOptions
                                              .map(
                                                (country) => Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    country.dialCode,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                              .toList();
                                        },
                                        items: countryPhoneOptions
                                            .map(
                                              (country) => DropdownMenuItem<
                                                CountryPhoneOption
                                              >(
                                                value: country,
                                                child: Text(
                                                  '${country.name} (${country.dialCode})',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            widget.onCountryPhoneChanged(value);
                                          }
                                        },
                                      ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: widget.contactNumberController,
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      labelText: 'Contact number',
                                      hintText: '812 0000 0000',
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Contact number is required.';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: constraints.maxWidth,
                        child: TextFormField(
                          controller: widget.primaryAddressController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Primary address',
                            hintText: 'Main project site or billing address',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Primary address is required.';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_showAdditionalAddress)
                        SizedBox(
                          width: constraints.maxWidth,
                          child: TextFormField(
                            controller: widget.secondaryAddressController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Additional address',
                              hintText:
                                  'Optional secondary site, warehouse, or office',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  widget.secondaryAddressController.clear();
                                  setState(() {
                                    _showAdditionalAddress = false;
                                  });
                                },
                                icon: const Icon(Icons.close_rounded),
                                tooltip: 'Remove additional address',
                              ),
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          width: constraints.maxWidth,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _showAdditionalAddress = true;
                                });
                              },
                              icon: const Icon(Icons.add_location_alt_outlined),
                              label: const Text('Add address'),
                            ),
                          ),
                        ),
                      SizedBox(
                        width: constraints.maxWidth,
                        child: TextFormField(
                          controller: widget.notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Notes',
                            hintText: 'Preferences, site timing, or project remarks',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: widget.onSubmit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text(
                    widget.submitLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
