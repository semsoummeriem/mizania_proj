// lib/core/services/prediction_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mizania_proj/core/services/supabase_client.dart';

class PredictionService {
  static const String _baseUrl = 'https://mizania-proj.onrender.com';

  Future<void> checkAndSavePredictionNotification() async {
    final userId = supabase.auth.currentUser!.id;
    final prediction = await getPrediction();

    const title = 'Prédiction du mois';

    // check if a prediction notification already exists for this user
    final existing = await supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .eq('type', 'prediction')
        .maybeSingle();

    if (prediction['prediction_available'] != true) {
      if (existing != null) {
        await supabase.from('notifications').delete().eq('id', existing['id']);
      }
      return;
    }

    final amount = prediction['predicted_amount'];
    final message =
        'Vous allez probablement dépenser environ ${amount.toStringAsFixed(0)} ce mois-ci.';

    if (existing == null) {
      await supabase.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'message': message,
        'type': 'prediction',
        'is_read': false,
      });
    } else {
      await supabase
          .from('notifications')
          .update({'message': message})
          .eq('id', existing['id']);
    }
  }

  Future<double> _getLastMonthTotal() async {
    final userId = supabase.auth.currentUser!.id;

    final now = DateTime.now();
    final firstDayOfThisMonth = DateTime(now.year, now.month, 1);
    final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);

    final response = await supabase
        .from('depense')
        .select('amount')
        .eq('user_id', userId)
        .gte('date', firstDayOfLastMonth.toIso8601String().substring(0, 10))
        .lt('date', firstDayOfThisMonth.toIso8601String().substring(0, 10));

    final expenses = response as List;
    double total = 0;
    for (var e in expenses) {
      total += (e['amount'] as num).toDouble();
    }
    return total;
  }

  Future<Map<String, dynamic>> getPrediction() async {
    final lastMonthTotal = await _getLastMonthTotal();

    if (lastMonthTotal <= 0) {
      return {
        'prediction_available': false,
        'message': 'Pas assez de données pour prédire',
      };
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'last_month_total': lastMonthTotal}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'prediction_available': true,
          'predicted_amount': data['predicted_next_month'],
          'last_month_total': lastMonthTotal,
        };
      } else {
        return {
          'prediction_available': false,
          'message': 'Erreur lors de la prédiction',
        };
      }
    } catch (e) {
      return {
        'prediction_available': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }
}
