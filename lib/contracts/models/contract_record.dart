class ContractSection {
  const ContractSection({
    required this.title,
    required this.lineItems,
    this.finish = '',
    this.sectionNotes = '',
  });

  final String title;
  final List<String> lineItems;
  final String finish;
  final String sectionNotes;

  factory ContractSection.fromMap(Map<String, dynamic> map) {
    final rawItems = map['line_items'] as List<dynamic>? ?? const [];

    return ContractSection(
      title: (map['title'] as String?) ?? '',
      lineItems: rawItems.map((item) => item.toString()).toList(),
      finish: (map['finish'] as String?) ?? '',
      sectionNotes: (map['section_notes'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'line_items': lineItems,
      'finish': finish,
      'section_notes': sectionNotes,
    };
  }
}

class ContractRecord {
  const ContractRecord({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.recipientName,
    required this.recipientAddress,
    required this.contractNumber,
    required this.subject,
    required this.projectTitle,
    required this.city,
    required this.status,
    required this.contractDate,
    required this.totalAmount,
    required this.sections,
    this.introMessage = '',
    this.materialDetails = '',
    this.closingNotes = '',
    required this.createdAt,
  });

  final String id;
  final String customerId;
  final String customerName;
  final String recipientName;
  final String recipientAddress;
  final String contractNumber;
  final String subject;
  final String projectTitle;
  final String city;
  final String status;
  final DateTime contractDate;
  final double totalAmount;
  final List<ContractSection> sections;
  final String introMessage;
  final String materialDetails;
  final String closingNotes;
  final DateTime createdAt;

  ContractRecord copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? recipientName,
    String? recipientAddress,
    String? contractNumber,
    String? subject,
    String? projectTitle,
    String? city,
    String? status,
    DateTime? contractDate,
    double? totalAmount,
    List<ContractSection>? sections,
    String? introMessage,
    String? materialDetails,
    String? closingNotes,
    DateTime? createdAt,
  }) {
    return ContractRecord(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      recipientName: recipientName ?? this.recipientName,
      recipientAddress: recipientAddress ?? this.recipientAddress,
      contractNumber: contractNumber ?? this.contractNumber,
      subject: subject ?? this.subject,
      projectTitle: projectTitle ?? this.projectTitle,
      city: city ?? this.city,
      status: status ?? this.status,
      contractDate: contractDate ?? this.contractDate,
      totalAmount: totalAmount ?? this.totalAmount,
      sections: sections ?? this.sections,
      introMessage: introMessage ?? this.introMessage,
      materialDetails: materialDetails ?? this.materialDetails,
      closingNotes: closingNotes ?? this.closingNotes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ContractRecord.fromMap(Map<String, dynamic> map) {
    final rawSections = map['sections'] as List<dynamic>? ?? const [];
    final totalAmountValue = map['total_amount'];

    return ContractRecord(
      id: map['id'] as String,
      customerId: map['customer_id'] as String,
      customerName: (map['customer_name'] as String?) ?? '',
      recipientName: (map['recipient_name'] as String?) ?? '',
      recipientAddress: (map['recipient_address'] as String?) ?? '',
      contractNumber: map['contract_number'] as String,
      subject: map['subject'] as String,
      projectTitle: map['project_title'] as String,
      city: (map['city'] as String?) ?? 'Surabaya',
      status: (map['status'] as String?) ?? 'Draft',
      contractDate: DateTime.parse(map['contract_date'] as String),
      totalAmount: totalAmountValue is int
          ? totalAmountValue.toDouble()
          : (totalAmountValue as num?)?.toDouble() ?? 0,
      sections: rawSections
          .map(
            (section) =>
                ContractSection.fromMap(section as Map<String, dynamic>),
          )
          .toList(),
      introMessage: (map['intro_message'] as String?) ?? '',
      materialDetails: (map['material_details'] as String?) ?? '',
      closingNotes: (map['closing_notes'] as String?) ?? '',
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return _toDatabaseMap();
  }

  Map<String, dynamic> toUpdateMap() {
    return _toDatabaseMap();
  }

  Map<String, dynamic> _toDatabaseMap() {
    return {
      'customer_id': customerId,
      'customer_name': customerName,
      'recipient_name': recipientName,
      'recipient_address': recipientAddress,
      'contract_number': contractNumber,
      'subject': subject,
      'project_title': projectTitle,
      'city': city,
      'status': status,
      'contract_date': contractDate.toIso8601String().split('T').first,
      'total_amount': totalAmount,
      'sections': sections.map((section) => section.toMap()).toList(),
      'intro_message': introMessage.isEmpty ? null : introMessage,
      'material_details': materialDetails.isEmpty ? null : materialDetails,
      'closing_notes': closingNotes.isEmpty ? null : closingNotes,
    };
  }
}
