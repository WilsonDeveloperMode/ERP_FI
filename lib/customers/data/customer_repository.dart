import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:erp_fi/customers/models/customer.dart';

class CustomerRepository {
  CustomerRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Customer>> fetchCustomers() async {
    final rows = await _client
        .from('customers')
        .select()
        .order('created_at', ascending: false);

    return rows.map((row) => Customer.fromMap(row)).toList();
  }

  Future<Customer> createCustomer(Customer customer) async {
    final row = await _client
        .from('customers')
        .insert(customer.toInsertMap())
        .select()
        .single();

    return Customer.fromMap(row);
  }

  Future<Customer> updateCustomer(Customer customer) async {
    final row = await _client
        .from('customers')
        .update(customer.toUpdateMap())
        .eq('id', customer.id)
        .select()
        .single();

    return Customer.fromMap(row);
  }
}
