import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service qui gère toutes les opérations backend de la page Profil :
/// lecture du profil, modification des infos, préférences,
/// changement de mot de passe, export des données et déconnexion.
class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Retourne l'utilisateur actuellement connecté (ou null si aucun).
  User? get currentUser => _client.auth.currentUser;

  // ---------------------------------------------------------------------
  // 1. LECTURE DU PROFIL
  // ---------------------------------------------------------------------

  /// Récupère toutes les infos du profil pour l'utilisateur connecté :
  /// nom, email, revenu, devise, préférences, nombre de dépenses,
  /// et mois suivis (calculés).
  Future<Map<String, dynamic>> getFullProfile() async {
    final user = currentUser;
    if (user == null) {
      throw Exception('Aucun utilisateur connecté.');
    }

    // 1. Données du profil (table `profiles`)
    final profileRow = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    // 2. Nombre de dépenses de l'utilisateur (table `depense`)
    final expensesCount = await _client
        .from('depense')
        .select('id')
        .eq('user_id', user.id)
        .count(CountOption.exact);

    // 3. Mois suivis = différence entre aujourd'hui et created_at
    final createdAt = DateTime.parse(profileRow['created_at'] as String);
    final monthsFollowed = _monthsBetween(createdAt, DateTime.now());

    return {
      'name': profileRow['name'],
      'email': user.email, // l'email vient de Supabase Auth, pas de profiles
      'role': profileRow['role'],
      'revenu_mensuel': profileRow['revenu_mensuel'],
      'devise': profileRow['devise'],
      'mode_sombre': profileRow['mode_sombre'],
      'notifications_actives': profileRow['notifications_actives'],
      'password_updated_at': profileRow['password_updated_at'],
      'expenses_count': expensesCount.count,
      'months_followed': monthsFollowed,
    };
  }

  int _monthsBetween(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }

  // ---------------------------------------------------------------------
  // 2. MODIFICATION DES INFOS DE COMPTE
  // ---------------------------------------------------------------------

  /// Met à jour le nom affiché dans la page Profil.
  Future<void> updateName(String newName) async {
    final user = currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    await _client.from('profiles').update({'name': newName}).eq('id', user.id);
  }

  /// Met à jour le revenu mensuel.
  Future<void> updateRevenuMensuel(double newRevenu) async {
    final user = currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    await _client
        .from('profiles')
        .update({'revenu_mensuel': newRevenu}).eq('id', user.id);
  }

  /// Met à jour la devise choisie (code ISO, ex: "EUR", "USD"...).
  Future<void> updateDevise(String currencyCode) async {
    final user = currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    await _client
        .from('profiles')
        .update({'devise': currencyCode}).eq('id', user.id);
  }

  /// Change l'email de l'utilisateur. Supabase envoie automatiquement un
  /// email de confirmation au nouvel email : le changement ne sera effectif
  /// qu'une fois le lien cliqué. On ne met donc PAS à jour `profiles` ici,
  /// l'email officiel reste celui d'Auth tant qu'il n'est pas confirmé.
  Future<void> updateEmail(String newEmail) async {
    final user = currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    await _client.auth.updateUser(UserAttributes(email: newEmail));
  }

  // ---------------------------------------------------------------------
  // 3. PRÉFÉRENCES (toggles)
  // ---------------------------------------------------------------------

  /// Active/désactive le mode sombre.
  Future<void> updateModeSombre(bool value) async {
    final user = currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    await _client
        .from('profiles')
        .update({'mode_sombre': value}).eq('id', user.id);
  }

  /// Active/désactive les notifications.
  Future<void> updateNotifications(bool value) async {
    final user = currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    await _client
        .from('profiles')
        .update({'notifications_actives': value}).eq('id', user.id);
  }

  // ---------------------------------------------------------------------
  // 3bis. CHANGEMENT D'EMAIL (avec confirmation)
  // ---------------------------------------------------------------------

  /// Demande le changement d'email. Supabase envoie automatiquement un
  /// email de confirmation à la nouvelle adresse (et parfois aussi à
  /// l'ancienne, selon la configuration du projet). L'email affiché dans
  /// l'app ne changera réellement qu'une fois le lien de confirmation cliqué.
  Future<void> requestEmailChange(String newEmail) async {
    final user = currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    try {
      await _client.auth.updateUser(UserAttributes(email: newEmail));
    } on AuthException catch (e) {
      throw Exception('Impossible de changer l\'email : ${e.message}');
    }
  }

  // ---------------------------------------------------------------------
  // 4. CHANGEMENT DE MOT DE PASSE
  // ---------------------------------------------------------------------

  /// Change le mot de passe. Vérifie d'abord l'ancien mot de passe
  /// en tentant une reconnexion, puis applique le nouveau.
  ///
  /// Lève une exception avec un message clair si l'ancien mot de passe
  /// est incorrect.
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = currentUser;
    if (user == null || user.email == null) {
      throw Exception('Aucun utilisateur connecté.');
    }

    // Étape 1 : vérifier l'ancien mot de passe en tentant une connexion
    try {
      await _client.auth.signInWithPassword(
        email: user.email!,
        password: oldPassword,
      );
    } on AuthException {
      throw Exception('Ancien mot de passe incorrect.');
    }

    // Étape 2 : appliquer le nouveau mot de passe
    await _client.auth.updateUser(UserAttributes(password: newPassword));

    // Étape 3 : enregistrer la date de changement dans profiles
    await _client
        .from('profiles')
        .update({'password_updated_at': DateTime.now().toIso8601String()})
        .eq('id', user.id);
  }

  // ---------------------------------------------------------------------
  // 5. EXPORT DES DONNÉES
  // ---------------------------------------------------------------------

  /// Récupère le profil + toutes les dépenses de l'utilisateur,
  /// crée un fichier JSON dans le dossier documents de l'appareil,
  /// et retourne le chemin du fichier créé (utilisable pour le partager).
  Future<File> exportUserData() async {
    final user = currentUser;
    if (user == null) throw Exception('Aucun utilisateur connecté.');

    final profileRow = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    final expenses = await _client
        .from('depense')
        .select()
        .eq('user_id', user.id);

    final exportData = {
      'profil': {
        ...profileRow,
        'email': user.email,
      },
      'depenses': expenses,
      'date_export': DateTime.now().toIso8601String(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/mizania_export_${user.id}.json');
    await file.writeAsString(jsonString);

    return file;
  }

  // ---------------------------------------------------------------------
  // 6. DÉCONNEXION
  // ---------------------------------------------------------------------

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}