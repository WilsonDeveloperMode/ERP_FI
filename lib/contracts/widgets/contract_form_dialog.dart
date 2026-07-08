import 'package:flutter/material.dart';

import 'package:erp_fi/contracts/models/contract_record.dart';
import 'package:erp_fi/customers/models/customer.dart';
import 'package:erp_fi/theme/app_colors.dart';

class ContractFormDialog extends StatefulWidget {
  const ContractFormDialog({
    required this.customers,
    required this.initialContractNumber,
    this.initialContract,
    this.onCreateCustomer,
    super.key,
  });

  final List<Customer> customers;
  final String initialContractNumber;
  final ContractRecord? initialContract;
  final Future<Customer?> Function()? onCreateCustomer;

  @override
  State<ContractFormDialog> createState() => _ContractFormDialogState();
}

class _ContractFormDialogState extends State<ContractFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _contractNumberController;
  final _subjectController = TextEditingController();
  final _projectTitleController = TextEditingController();
  final _cityController = TextEditingController(text: 'Surabaya');
  final _recipientNameController = TextEditingController();
  final _recipientAddressController = TextEditingController();
  final _introController = TextEditingController();
  final _materialDetailsController = TextEditingController();
  final _closingNotesController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final List<_SectionInput> _sections = [];

  late List<Customer> _availableCustomers;
  Customer? _selectedCustomer;
  DateTime _contractDate = DateTime.now();
  String _selectedStatus = 'Draft';
  String? _customerError;

  bool get _isEditing => widget.initialContract != null;

  @override
  void initState() {
    super.initState();
    _availableCustomers = List<Customer>.from(widget.customers);
    _contractNumberController = TextEditingController(
      text: widget.initialContractNumber,
    );
    _seedInitialState();
  }

  @override
  void didUpdateWidget(covariant ContractFormDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.customers != widget.customers) {
      _availableCustomers = List<Customer>.from(widget.customers);
    }
  }

  @override
  void dispose() {
    _contractNumberController.dispose();
    _subjectController.dispose();
    _projectTitleController.dispose();
    _cityController.dispose();
    _recipientNameController.dispose();
    _recipientAddressController.dispose();
    _introController.dispose();
    _materialDetailsController.dispose();
    _closingNotesController.dispose();
    _totalAmountController.dispose();
    for (final section in _sections) {
      section.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 940, maxHeight: 860),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border),
          ),
          child: _availableCustomers.isEmpty
              ? _EmptyCustomerState(onClose: () => Navigator.of(context).pop())
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isEditing ? 'Edit contract' : 'New contract',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(color: AppColors.ink),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _isEditing
                                      ? 'Update project scope, pricing, materials, and customer-facing details.'
                                      : 'Create a customer-based contract using the same structure as your sample offer.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeaderFields(),
                              const SizedBox(height: 20),
                              _buildTextArea(
                                controller: _introController,
                                label: 'Opening paragraph',
                                minLines: 2,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Contract sections',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: _addSection,
                                    icon: const Icon(Icons.add_rounded),
                                    label: const Text('Add section'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ..._buildSectionEditors(),
                              const SizedBox(height: 8),
                              _buildTextArea(
                                controller: _materialDetailsController,
                                label: 'Material details / options',
                                hintText:
                                    'Example: Aluminium glass doors, timber veneer doors, PVC protection, toe kick details.',
                                minLines: 3,
                              ),
                              const SizedBox(height: 16),
                              _buildTextArea(
                                controller: _closingNotesController,
                                label: 'Closing notes',
                                hintText:
                                    'Example: Installation included, protection from moisture, thank-you note.',
                                minLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: _submit,
                            child: Text(
                              _isEditing ? 'Save changes' : 'Save contract',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void _seedInitialState() {
    final initialContract = widget.initialContract;
    if (initialContract == null) {
      _introController.text =
          'Menindaklanjuti pembicaraan kita, dengan ini kami mengajukan perincian pekerjaan sebagai berikut:';
      if (_availableCustomers.isNotEmpty) {
        _selectedCustomer = _availableCustomers.first;
        _applyCustomer(_selectedCustomer!);
      }
      _addSection();
      return;
    }

    Customer? matchedCustomer;
    for (final customer in _availableCustomers) {
      if (customer.id == initialContract.customerId) {
        matchedCustomer = customer;
        break;
      }
    }
    _selectedCustomer = matchedCustomer;
    _contractNumberController.text = initialContract.contractNumber;
    _subjectController.text = initialContract.subject;
    _projectTitleController.text = initialContract.projectTitle;
    _cityController.text = initialContract.city;
    _recipientNameController.text = initialContract.recipientName;
    _recipientAddressController.text = initialContract.recipientAddress;
    _introController.text = initialContract.introMessage;
    _materialDetailsController.text = initialContract.materialDetails;
    _closingNotesController.text = initialContract.closingNotes;
    _totalAmountController.text = initialContract.totalAmount.toStringAsFixed(
      0,
    );
    _contractDate = initialContract.contractDate;
    _selectedStatus = initialContract.status;

    for (final section in initialContract.sections) {
      _sections.add(
        _SectionInput(
          title: section.title,
          items: section.lineItems.join('\n'),
          finish: section.finish,
          notes: section.sectionNotes,
        ),
      );
    }

    if (_sections.isEmpty) {
      _addSection();
    }
  }

  Widget _buildHeaderFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildCustomerField(context)),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _contractNumberController,
                decoration: const InputDecoration(labelText: 'Contract number'),
                validator: (value) =>
                    _requiredValue(value, 'Enter a contract number.'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Subject / Hal'),
                validator: (value) =>
                    _requiredValue(value, 'Enter the subject.'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _projectTitleController,
                decoration: const InputDecoration(labelText: 'Project title'),
                validator: (value) =>
                    _requiredValue(value, 'Enter the project title.'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'Draft', child: Text('Draft')),
                  DropdownMenuItem(
                    value: 'Pending Approval',
                    child: Text('Pending Approval'),
                  ),
                  DropdownMenuItem(value: 'Active', child: Text('Active')),
                  DropdownMenuItem(
                    value: 'Completed',
                    child: Text('Completed'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Contract date'),
                  child: Text(_dateLabel(_contractDate)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _recipientNameController,
                decoration: const InputDecoration(labelText: 'Recipient name'),
                validator: (value) =>
                    _requiredValue(value, 'Enter the recipient name.'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) => _requiredValue(value, 'Enter the city.'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextArea(
          controller: _recipientAddressController,
          label: 'Recipient address',
          minLines: 2,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _totalAmountController,
          decoration: const InputDecoration(
            labelText: 'Total amount',
            hintText: 'Example: 1250000000',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if ((value ?? '').trim().isEmpty) {
              return 'Enter the total amount.';
            }

            final normalized = value!.replaceAll(',', '').trim();
            if (double.tryParse(normalized) == null) {
              return 'Enter numbers only.';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCustomerField(BuildContext context) {
    final selectedCustomer = _selectedCustomer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: _pickCustomer,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _customerError == null
                    ? AppColors.border
                    : AppColors.danger,
              ),
            ),
            child: selectedCustomer == null
                ? const Text('Choose customer')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedCustomer.fullName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedCustomer.contactPerson?.trim().isNotEmpty ==
                                true
                            ? selectedCustomer.contactPerson!
                            : selectedCustomer.contactNumber,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedCustomer.primaryAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (_customerError != null) ...[
          const SizedBox(height: 6),
          Text(
            _customerError!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.danger),
          ),
        ],
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(
              onPressed: _pickCustomer,
              icon: const Icon(Icons.search_rounded),
              label: Text(
                selectedCustomer == null ? 'Find customer' : 'Change',
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: _createCustomerQuick,
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('New customer'),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildSectionEditors() {
    return _sections.asMap().entries.map((entry) {
      final index = entry.key;
      final section = entry.value;

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
                    'Section ${index + 1}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (_sections.length > 1)
                  IconButton(
                    onPressed: () => _removeSection(index),
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: section.titleController,
              decoration: const InputDecoration(labelText: 'Area / room title'),
              validator: (value) =>
                  _requiredValue(value, 'Enter the section title.'),
            ),
            const SizedBox(height: 14),
            _buildTextArea(
              controller: section.itemsController,
              label: 'Items (one line per item)',
              hintText:
                  'Example:\nWardrobe 1 Uk. (224x60x270)\nCermin Full Dinding Euro Grey Uk. (252x240)',
              minLines: 4,
              validator: (value) {
                final lines = _linesFrom(value ?? '');
                return lines.isEmpty ? 'Enter at least one item.' : null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: section.finishController,
              decoration: const InputDecoration(
                labelText: 'Finish / option summary',
              ),
            ),
            const SizedBox(height: 14),
            _buildTextArea(
              controller: section.notesController,
              label: 'Section notes',
              minLines: 2,
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    String? hintText,
    int minLines = 3,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: minLines + 2,
      validator: validator,
      decoration: InputDecoration(labelText: label, hintText: hintText),
    );
  }

  void _applyCustomer(Customer customer) {
    _recipientNameController.text =
        customer.contactPerson?.trim().isNotEmpty == true
        ? customer.contactPerson!
        : customer.fullName;
    _recipientAddressController.text = customer.primaryAddress;
    _customerError = null;
  }

  Future<void> _pickCustomer() async {
    final customer = await showDialog<Customer>(
      context: context,
      builder: (context) => _CustomerPickerDialog(
        customers: _availableCustomers,
        selectedCustomerId: _selectedCustomer?.id,
      ),
    );

    if (customer == null || !mounted) {
      return;
    }

    setState(() {
      _selectedCustomer = customer;
      _applyCustomer(customer);
    });
  }

  Future<void> _createCustomerQuick() async {
    final callback = widget.onCreateCustomer;
    if (callback == null) {
      return;
    }

    final customer = await callback();
    if (customer == null || !mounted) {
      return;
    }

    setState(() {
      _availableCustomers = [customer, ..._availableCustomers];
      _selectedCustomer = customer;
      _applyCustomer(customer);
    });
  }

  void _addSection() {
    setState(() {
      _sections.add(_SectionInput());
    });
  }

  void _removeSection(int index) {
    setState(() {
      final removed = _sections.removeAt(index);
      removed.dispose();
    });
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _contractDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _contractDate = pickedDate;
    });
  }

  void _submit() {
    final hasValidForm = _formKey.currentState!.validate();
    final customer = _selectedCustomer;

    setState(() {
      _customerError = customer == null ? 'Please choose a customer.' : null;
    });

    if (!hasValidForm || customer == null) {
      return;
    }

    final normalizedAmount = _totalAmountController.text
        .replaceAll(',', '')
        .trim();
    final initialContract = widget.initialContract;

    final contract = ContractRecord(
      id: initialContract?.id ?? '',
      customerId: customer.id,
      customerName: customer.fullName,
      recipientName: _recipientNameController.text.trim(),
      recipientAddress: _recipientAddressController.text.trim(),
      contractNumber: _contractNumberController.text.trim(),
      subject: _subjectController.text.trim(),
      projectTitle: _projectTitleController.text.trim(),
      city: _cityController.text.trim(),
      status: _selectedStatus,
      contractDate: _contractDate,
      totalAmount: double.parse(normalizedAmount),
      sections: _sections
          .map(
            (section) => ContractSection(
              title: section.titleController.text.trim(),
              lineItems: _linesFrom(section.itemsController.text),
              finish: section.finishController.text.trim(),
              sectionNotes: section.notesController.text.trim(),
            ),
          )
          .toList(),
      introMessage: _introController.text.trim(),
      materialDetails: _materialDetailsController.text.trim(),
      closingNotes: _closingNotesController.text.trim(),
      createdAt: initialContract?.createdAt ?? DateTime.now(),
    );

    Navigator.of(context).pop(contract);
  }

  String _dateLabel(DateTime value) {
    final month = switch (value.month) {
      1 => 'Jan',
      2 => 'Feb',
      3 => 'Mar',
      4 => 'Apr',
      5 => 'May',
      6 => 'Jun',
      7 => 'Jul',
      8 => 'Aug',
      9 => 'Sep',
      10 => 'Oct',
      11 => 'Nov',
      _ => 'Dec',
    };

    return '${value.day.toString().padLeft(2, '0')} $month ${value.year}';
  }

  List<String> _linesFrom(String rawValue) {
    return rawValue
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  String? _requiredValue(String? value, String message) {
    if ((value ?? '').trim().isEmpty) {
      return message;
    }

    return null;
  }
}

class _SectionInput {
  _SectionInput({
    String title = '',
    String items = '',
    String finish = '',
    String notes = '',
  }) : titleController = TextEditingController(text: title),
       itemsController = TextEditingController(text: items),
       finishController = TextEditingController(text: finish),
       notesController = TextEditingController(text: notes);

  final TextEditingController titleController;
  final TextEditingController itemsController;
  final TextEditingController finishController;
  final TextEditingController notesController;

  void dispose() {
    titleController.dispose();
    itemsController.dispose();
    finishController.dispose();
    notesController.dispose();
  }
}

class _CustomerPickerDialog extends StatefulWidget {
  const _CustomerPickerDialog({
    required this.customers,
    required this.selectedCustomerId,
  });

  final List<Customer> customers;
  final String? selectedCustomerId;

  @override
  State<_CustomerPickerDialog> createState() => _CustomerPickerDialogState();
}

class _CustomerPickerDialogState extends State<_CustomerPickerDialog> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCustomers = widget.customers.where((customer) {
      if (_query.isEmpty) {
        return true;
      }

      final query = _query.toLowerCase();
      return customer.fullName.toLowerCase().contains(query) ||
          customer.contactNumber.toLowerCase().contains(query) ||
          customer.primaryAddress.toLowerCase().contains(query) ||
          (customer.contactPerson ?? '').toLowerCase().contains(query);
    }).toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 720),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose customer',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: AppColors.ink),
              ),
              const SizedBox(height: 6),
              Text(
                'Search by customer name, PIC, phone number, or address.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _query = value.trim();
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Search customer',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: filteredCustomers.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.canvas,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('No customers match your search.'),
                      )
                    : ListView.separated(
                        itemCount: filteredCustomers.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final customer = filteredCustomers[index];
                          final isSelected =
                              customer.id == widget.selectedCustomerId;

                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => Navigator.of(context).pop(customer),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.surfaceTint
                                    : AppColors.canvas,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customer.fullName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: AppColors.ink,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    customer.contactPerson?.trim().isNotEmpty ==
                                            true
                                        ? 'PIC: ${customer.contactPerson}'
                                        : customer.contactNumber,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    customer.contactNumber,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    customer.primaryAddress,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCustomerState extends StatelessWidget {
  const _EmptyCustomerState({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.people_outline_rounded,
            size: 42,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 14),
          Text(
            'Create a customer first',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Contracts are linked to customers, so the customer record needs to exist before this document can be created.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onClose, child: const Text('Close')),
        ],
      ),
    );
  }
}
