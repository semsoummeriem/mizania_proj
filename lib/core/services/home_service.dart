import 'package:supabase_flutter/supabase_flutter.dart';

/// Service qui gère les données de la page Home : répartition des dépenses
/// du mois par catégorie, et les dernières dépenses enregistrées.
class HomeService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Retourne, pour le mois donné, le total dépensé par catégorie, avec
  /// les infos de la catégorie (nom, icône, couleur) directement jointes.
  /// Chaque élément de la liste ressemble à :
  /// { 'name': 'Nourriture', 'icon': 'fastfood', 'color': '#EC4899', 'amount': 310.0 }
  Future<List<Map<String, dynamic>>> getCategoryBreakdown(DateTime month) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);

    final rows = await _client
        .from('depense')
        .select('amount, category_id, categories(name, icon, color)')
        .eq('user_id', user.id)
        .gte('date', start.toIso8601String().split('T').first)
        .lt('date', end.toIso8601String().split('T').first);

    // On regroupe côté Dart les dépenses par catégorie (somme des montants).
    final Map<int, Map<String, dynamic>> grouped = {};
    for (final row in rows as List) {
      final categoryId = row['category_id'] as int?;
      if (categoryId == null) continue;

      final amount = (row['amount'] as num?)?.toDouble() ?? 0;
      final categoryInfo = row['categories'] as Map<String, dynamic>?;

      grouped.putIfAbsent(
        categoryId,
        () => {
          'name': categoryInfo?['name'] ?? 'Autres',
          'icon': categoryInfo?['icon'] ?? 'category',
          'color': categoryInfo?['color'] ?? '#8B5E34',
          'amount': 0.0,
        },
      );
      grouped[categoryId]!['amount'] = (grouped[categoryId]!['amount'] as double) + amount;
    }

    return grouped.values.toList();
  }

  /// Retourne les [limit] dernières dépenses (toutes catégories confondues),
  /// de la plus récente à la plus ancienne, avec les infos de catégorie jointes.
  Future<List<Map<String, dynamic>>> getRecentExpenses({int limit = 3}) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    final rows = await _client
        .from('depense')
        .select('amount, date, description, categories(name, icon, color)')
        .eq('user_id', user.id)
        .order('date', ascending: false)
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(rows as List);
  }
}