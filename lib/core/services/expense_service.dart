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

  Future<Map<String, dynamic>> getResumeMensuel({
    required int year,
    required int month,
  }) async {
    final res = await supabase.rpc('get_resume_mensuel', params: {
      'p_year': year,
      'p_month': month,
    }).single();

    return res;
  }

  Future<List<Map<String, dynamic>>> getDepensesDuMois({
    required int year,
    required int month,
    int? categoryId,
    String? search,
  }) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    var query = supabase
        .from('depense')
        .select('id, description, amount, date, category_id, categories(name, icon, color)')
        .gte('date', start.toIso8601String())
        .lt('date', end.toIso8601String());

    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    if (search != null && search.isNotEmpty) {
      query = query.ilike('description', '%$search%');
    }

    final data = await query.order('date', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> updateExpense({
    required int id,
    required double amount,
    String? description,
    required int categoryId,
    required DateTime date,
  }) async {
    await supabase.from('depense').update({
      'amount': amount,
      'description': description,
      'category_id': categoryId,
      'date': date.toIso8601String(),
    }).eq('id', id);
  }

  Future<void> deleteExpense(int id) async {
    await supabase.from('depense').delete().eq('id', id);
  }
}