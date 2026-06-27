class SummaryCardData {
  const SummaryCardData(this.label, this.value);

  final String label;
  final String value;
}

class ContractRow {
  const ContractRow({
    required this.contractNo,
    required this.customer,
    required this.project,
    required this.value,
    required this.status,
  });

  final String contractNo;
  final String customer;
  final String project;
  final String value;
  final String status;
}

class PaymentRow {
  const PaymentRow(this.stage, this.dueDate, this.amount, this.status);

  final String stage;
  final String dueDate;
  final String amount;
  final String status;
}

class CustomerRow {
  const CustomerRow(this.id, this.company, this.pic, this.status);

  final String id;
  final String company;
  final String pic;
  final String status;
}

class KeyValueEntry {
  const KeyValueEntry(this.label, this.value);

  final String label;
  final String value;
}
