class Customer {
  const Customer({
    required this.id,
    required this.companyName,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.address,
    required this.createdAt,
  });

  final String id;
  final String companyName;
  final String contactPerson;
  final String email;
  final String phone;
  final String address;
  final DateTime createdAt;
}
