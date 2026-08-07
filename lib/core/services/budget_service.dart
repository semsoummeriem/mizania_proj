import 'package:supabase_flutter/supabase_flutter.dart';

/// Service qui gère toutes les opérations backend de la page Budget :
/// récupération des catégories (par défaut + personnalisées de l'utilisateur),
/// lecture/écriture du budget du mois, et calcul des dépenses par catégorie.
class BudgetService {
  final SupabaseClient _client = Supabase.instance.client;

  String get _monthKey => 'month';

  String _formatMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    return firstDay.toIso8601String().split('T').first; // ex: "2026-06-01"
  }

  /// Récupère toutes les catégories utilisables par l'utilisateur :
  /// les catégories par défaut (user_id = null) + ses catégories perso.
  Future<List<Map<String, dynamic>>> getUserCategories() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    final rows = await _client
        .from('categories')
        .select()
        .or('user_id.is.null,user_id.eq.${user.id}')
        .order('id');

    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Récupère le budget déjà enregistré pour un mois donné.
  /// Retourne une map { category_id: montant_alloué }.
  Future<Map<int, double>> getBudgetForMonth(DateTime month) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    final rows = await _client
        .from('budgets')
        .select('category_id, allocated')
        .eq('user_id', user.id)
        .eq(_monthKey, _formatMonth(month));

    final Map<int, double> result = {};
    for (final row in rows as List) {
      result[row['category_id'] as int] = (row['allocated'] as num).toDouble();
    }
    return result;
  }

  /// Calcule le total dépensé par catégorie pour un mois donné, à partir
  /// des vraies dépenses enregistrées dans la table `depense`.
  /// Retourne une map { category_id: total_dépensé }.
  Future<Map<int, double>> getSpentForMonth(DateTime month) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final rows = await _client
        .from('depense')
        .select('amount, category_id')
        .eq('user_id', user.id)
        .gte('date', start.toIso8601String().split('T').first)
        .lt('date', end.toIso8601String().split('T').first);

    final Map<int, double> result = {};
    for (final row in rows as List) {
      final categoryId = row['category_id'] as int?;
      final amount = (row['amount'] as num?)?.toDouble() ?? 0;
      if (categoryId != null) {
        result[categoryId] = (result[categoryId] ?? 0) + amount;
      }
    }
    return result;
  }

  /// Enregistre (ou met à jour) le budget du mois pour plusieurs catégories
  /// en une seule fois. `allocations` est une map { category_id: montant }.
  Future<void> saveBudget(DateTime month, Map<int, double> allocations) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    final monthStr = _formatMonth(month);
    final rows = allocations.entries
        .map((entry) => {
              'user_id': user.id,
              'category_id': entry.key,
              'month': monthStr,
              'allocated': entry.value,
              'updated_at': DateTime.now().toIso8601String(),
            })
        .toList();

    if (rows.isEmpty) return;

    await _client.from('budgets').upsert(
          rows,
          onConflict: 'user_id,category_id,month',
        );
  }
}