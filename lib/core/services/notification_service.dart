import 'package:supabase_flutter/supabase_flutter.dart';

/// Service qui gère la persistance des notifications dans Supabase.
class NotificationService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Crée (ou met à jour) la notification de prédiction du mois pour
  /// l'utilisateur. Une seule notification de ce type par mois (le
  /// category_id reste null pour ce type).
  Future<void> upsertPredictionNotification({
    required DateTime month,
    required String title,
    required String message,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    await _client.from('notifications').upsert({
      'user_id': user.id,
      'category_id': null,
      'month': _formatMonth(month),
      'type': 'prediction',
      'title': title,
      'message': message,
    }, onConflict: 'user_id,category_id,month,type');
  }

  Future<void> deletePredictionNotification({required DateTime month}) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    await _client
        .from('notifications')
        .delete()
        .eq('user_id', user.id)
        .eq('month', _formatMonth(month))
        .eq('type', 'prediction');
  }

  String _formatMonth(DateTime month) {
    return DateTime(
      month.year,
      month.month,
      1,
    ).toIso8601String().split('T').first;
  }

  /// Récupère toutes les notifications de l'utilisateur, les plus récentes en premier.
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    final rows = await _client
        .from('notifications')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(rows as List);
  }

  /// Crée (ou met à jour si elle existe déjà pour cette catégorie/ce mois)
  /// une alerte de dépassement de budget. Grâce à la contrainte unique sur
  /// (user_id, category_id, month, type), le statut lu/non-lu existant
  /// n'est jamais écrasé : seuls title/message sont mis à jour.
  Future<void> upsertBudgetOverspendNotification({
    required int categoryId,
    required DateTime month,
    required String title,
    required String message,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    await _client.from('notifications').upsert({
      'user_id': user.id,
      'category_id': categoryId,
      'month': _formatMonth(month),
      'type': 'budget_overspend',
      'title': title,
      'message': message,
    }, onConflict: 'user_id,category_id,month,type');
  }

  /// Supprime l'alerte de dépassement d'une catégorie pour un mois donné
  /// (utilisé quand la catégorie repasse sous son budget).
  Future<void> deleteBudgetOverspendNotification({
    required int categoryId,
    required DateTime month,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    await _client
        .from('notifications')
        .delete()
        .eq('user_id', user.id)
        .eq('category_id', categoryId)
        .eq('month', _formatMonth(month))
        .eq('type', 'budget_overspend');
  }

  Future<void> markAsRead(int notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  Future<void> markAllAsRead() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', user.id);
  }
}
