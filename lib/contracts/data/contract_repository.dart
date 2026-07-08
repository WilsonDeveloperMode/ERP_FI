import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:erp_fi/contracts/models/contract_record.dart';

class ContractRepository {
  ContractRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<ContractRecord>> fetchContracts() async {
    final rows = await _client
        .from('contracts')
        .select()
        .order('contract_date', ascending: false)
        .order('created_at', ascending: false);

    return rows.map((row) => ContractRecord.fromMap(row)).toList();
  }

  Future<ContractRecord> createContract(ContractRecord contract) async {
    final row = await _client
        .from('contracts')
        .insert(contract.toInsertMap())
        .select()
        .single();

    return ContractRecord.fromMap(row);
  }

  Future<ContractRecord> updateContract(ContractRecord contract) async {
    final row = await _client
        .from('contracts')
        .update(contract.toUpdateMap())
        .eq('id', contract.id)
        .select()
        .single();

    return ContractRecord.fromMap(row);
  }
}
