import "package:flutter/material.dart";
import "package:mizania_proj/core/services/supabase_client.dart";

class ExpenseService {
  Future<void> addExpense({
    required double amount,
    String? description,
    required int categoryId,
    required DateTime date,
  }) async {
    final userId = supabase.auth.currentUser!.id;
    await supabase.from('depense').insert({
      'user_id': userId,
      'amount': amount,
      'description': description,
      'category_id': categoryId,
      'date': date.toIso8601String(),
    });
  }
}
