class Customer {
  const Customer({
    required this.id,
    required this.fullName,
    required this.contactNumber,
    required this.email,
    required this.status,
    required this.addresses,
    this.contactPerson,
    this.customerType = 'Residential',
    this.notes = '',
    required this.createdAt,
  });

  final String id;
  final String fullName;
  final String contactNumber;
  final String email;
  final String status;
  final List<String> addresses;
  final String? contactPerson;
  final String customerType;
  final String notes;
  final DateTime createdAt;

  String get primaryAddress => addresses.first;

  Customer copyWith({
    String? id,
    String? fullName,
    String? contactNumber,
    String? email,
    String? status,
    List<String>? addresses,
    String? contactPerson,
    String? customerType,
    String? notes,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      contactPerson: contactPerson ?? this.contactPerson,
      customerType: customerType ?? this.customerType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    final rawAddresses = map['addresses'] as List<dynamic>? ?? const [];

    return Customer(
      id: map['id'] as String,
      fullName: map['full_name'] as String,
      contactNumber: map['contact_number'] as String,
      email: (map['email'] as String?) ?? '',
      status: (map['status'] as String?) ?? 'Active',
      addresses: rawAddresses.cast<String>(),
      contactPerson: map['contact_person'] as String?,
      customerType: (map['customer_type'] as String?) ?? 'Residential',
      notes: (map['notes'] as String?) ?? '',
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'full_name': fullName,
      'contact_number': contactNumber,
      'email': email.isEmpty ? null : email,
      'status': status,
      'addresses': addresses,
      'contact_person': contactPerson?.isEmpty ?? true ? null : contactPerson,
      'customer_type': customerType,
      'notes': notes.isEmpty ? null : notes,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'full_name': fullName,
      'contact_number': contactNumber,
      'email': email.isEmpty ? null : email,
      'status': status,
      'addresses': addresses,
      'contact_person': contactPerson?.isEmpty ?? true ? null : contactPerson,
      'customer_type': customerType,
      'notes': notes.isEmpty ? null : notes,
    };
  }
}
