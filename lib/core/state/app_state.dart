import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/icon_map.dart';
import '../../features/screens/profile/currency_model.dart';
import '../services/profile_service.dart';
import '../services/budget_service.dart';

/// Une catégorie de dépense avec son montant (utilisée pour le donut chart de la Home).
class CategoryAmount {
  final String label;
  final double amount;
  final Color color;

  const CategoryAmount({
    required this.label,
    required this.amount,
    required this.color,
  });
}

/// Une dépense récente affichée dans la liste "Dernières dépenses".
class ExpenseItem {
  final String category;
  final String date;
  final double amount;
  final IconData icon;
  final Color iconBackground;

  const ExpenseItem({
    required this.category,
    required this.date,
    required this.amount,
    required this.icon,
    required this.iconBackground,
  });
}

/// Une vraie dépense enregistrée par l'utilisateur, utilisée dans la page
/// Historique et sa page de détail (contrairement à ExpenseItem qui n'est
/// qu'un affichage simplifié pour la Home).
class Expense {
  final String id;
  String description;
  String category;
  IconData icon;
  Color iconBackground;
  DateTime date;
  double amount;

  Expense({
    required this.id,
    required this.description,
    required this.category,
    required this.icon,
    required this.iconBackground,
    required this.date,
    required this.amount,
  });
}

/// Le budget alloué à une catégorie de dépense (page Budgets).
class BudgetCategory {
  final int? categoryId; // id réel de la catégorie dans Supabase (null = ancien mock)
  final String label;
  final IconData icon;
  final Color iconBackground;
  final Color accentColor;
  double allocated;
  double spent; // total réellement dépensé ce mois-ci dans cette catégorie

  BudgetCategory({
    this.categoryId,
    required this.label,
    required this.icon,
    required this.iconBackground,
    required this.accentColor,
    required this.allocated,
    this.spent = 0,
  });

  bool get isOverBudget => allocated > 0 && spent > allocated;
}

/// Une notification affichée sur la page Notifications.
class AppNotification {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final bool isRead;

  const AppNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    this.isRead = false,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      title: title,
      message: message,
      time: time,
      icon: icon,
      iconBackground: iconBackground,
      iconColor: iconColor,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// État partagé de toute l'application.
///
/// PRINCIPE : au lieu que chaque page (Home, Profil...) ait ses PROPRES variables
/// "nom", "revenu", etc. (ce qui les désynchroniserait), toutes les pages lisent
/// et modifient les MÊMES variables, stockées ici, une seule fois.
///
/// Cette classe "notifie" ses auditeurs (notifyListeners()) à chaque changement.
/// Toute page qui la lit via `AppStateScope.of(context)` se reconstruit
/// automatiquement dès qu'une valeur change, où que ce soit dans l'app.
class AppState extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();

  // ---- Profil utilisateur ----
  // Valeurs par défaut affichées le temps que loadProfile() récupère les
  // vraies données depuis Supabase (évite un écran vide au démarrage).
  String userName = '...';
  String userEmail = '...';
  double monthlyIncome = 0;
  Currency selectedCurrency = availableCurrencies.first;
  String passwordLastUpdateLabel = '...';
  bool isDarkMode = false;
  bool notificationsOn = false;

  // Statistiques calculées depuis Supabase (nombre de dépenses, mois suivis)
  int expensesCount = 0;
  int monthsFollowed = 0;

  // true pendant le chargement initial du profil depuis Supabase
  bool isProfileLoading = false;

  /// À appeler une fois, juste après la connexion/inscription réussie
  /// (typiquement dans le splash screen ou la page de connexion),
  /// pour remplir toutes les valeurs ci-dessus avec les vraies données.
  Future<void> loadProfile() async {
    isProfileLoading = true;
    notifyListeners();
    try {
      final data = await _profileService.getFullProfile();

      userName = (data['name'] as String?) ?? userName;
      userEmail = (data['email'] as String?) ?? userEmail;
      monthlyIncome = (data['revenu_mensuel'] as num?)?.toDouble() ?? monthlyIncome;

      final currencyCode = data['devise'] as String?;
      if (currencyCode != null) {
        selectedCurrency = availableCurrencies.firstWhere(
          (c) => c.code == currencyCode,
          orElse: () => selectedCurrency,
        );
      }

      isDarkMode = (data['mode_sombre'] as bool?) ?? isDarkMode;
      notificationsOn = (data['notifications_actives'] as bool?) ?? notificationsOn;
      expensesCount = (data['expenses_count'] as int?) ?? 0;
      monthsFollowed = (data['months_followed'] as int?) ?? 0;
      passwordLastUpdateLabel = _formatPasswordLabel(data['password_updated_at'] as String?);
    } catch (e) {
      debugPrint('Erreur lors du chargement du profil : $e');
    } finally {
      isProfileLoading = false;
      notifyListeners();
    }
  }

  String _formatPasswordLabel(String? isoDate) {
    if (isoDate == null) return 'Jamais modifié';
    final date = DateTime.tryParse(isoDate);
    if (date == null) return 'Jamais modifié';
    final months = _monthsBetween(date, DateTime.now());
    if (months <= 0) return 'Dernière modif. à l\'instant';
    if (months == 1) return 'Dernière modif. il y a 1 mois';
    return 'Dernière modif. il y a $months mois';
  }

  int _monthsBetween(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }

  // ---- Données du mois affichées sur la Home ----
  // TODO: ces valeurs viendront plus tard du vrai calcul des dépenses
  // ajoutées par l'utilisateur (bouton "+"), au lieu d'être fixes.
  String currentMonthLabel = 'Juin 2026';
  double totalSpentThisMonth = 740;

  List<CategoryAmount> categoryBreakdown = [
    CategoryAmount(label: 'Nourriture', amount: 310, color: AppColors.blueColor),
    CategoryAmount(label: 'Transport', amount: 200, color: AppColors.tealColor),
    CategoryAmount(label: 'Loisirs', amount: 120, color: AppColors.roseColor),
    CategoryAmount(label: 'Logement', amount: 110, color: AppColors.amberColor),
  ];

  List<ExpenseItem> recentExpenses = [
    ExpenseItem(
      category: 'Nourriture',
      date: '27 juin',
      amount: 35,
      icon: Icons.shopping_cart_outlined,
      iconBackground: AppColors.blueLightColor,
    ),
    ExpenseItem(
      category: 'Transport',
      date: '25 juin',
      amount: 12,
      icon: Icons.directions_bus_outlined,
      iconBackground: AppColors.greenLightColor,
    ),
    ExpenseItem(
      category: 'Loisirs',
      date: '20 juin',
      amount: 10,
      icon: Icons.movie_outlined,
      iconBackground: AppColors.redLightColor,
    ),
  ];

  // ---- Notifications ----
  List<AppNotification> notifications = [
    AppNotification(
      title: 'Budget Loisirs dépassé',
      message: 'Tu as dépensé 230 € sur 200 € prévus ce mois-ci.',
      time: 'Il y a 12 min',
      icon: Icons.warning_amber_rounded,
      iconBackground: AppColors.redLightColor,
      iconColor: AppColors.redColor,
    ),
    AppNotification(
      title: 'Prédiction du mois',
      message: 'À ce rythme, tu vas dépenser ~1 820 € en juillet. Sous ton revenu.',
      time: 'Il y a 2 h',
      icon: Icons.trending_up,
      iconBackground: AppColors.orangeLightColor,
      iconColor: AppColors.amberColor,
    ),
    AppNotification(
      title: 'Nourriture en hausse',
      message: 'Tes dépenses Nourriture sont 28 % plus élevées qu\'en mai.',
      time: 'Il y a 5 h',
      icon: Icons.trending_down,
      iconBackground: AppColors.orangeLightColor,
      iconColor: AppColors.amberColor,
    ),
    AppNotification(
      title: 'Budget Transport respecté',
      message: 'Tu es à 110 sur 150 € prévus. Bonne maîtrise ce mois-ci.',
      time: 'Hier, 09:15',
      icon: Icons.check,
      iconBackground: AppColors.greenLightColor,
      iconColor: AppColors.greenColor,
      isRead: true,
    ),
    AppNotification(
      title: 'Revenu du mois reçu',
      message: 'Un revenu de 2 000 € a été enregistré pour juin 2026.',
      time: '27 juin, 08:00',
      icon: Icons.attach_money,
      iconBackground: AppColors.purpleLightColor,
      iconColor: AppColors.darkmauveColor,
      isRead: true,
    ),
    AppNotification(
      title: 'Budget Santé à 90 %',
      message: 'Il te reste seulement 10 € sur ton budget Santé de ce mois.',
      time: '26 juin, 14:30',
      icon: Icons.error_outline,
      iconBackground: AppColors.redLightColor,
      iconColor: AppColors.redColor,
      isRead: true,
    ),
    AppNotification(
      title: 'Récap de mi-mois',
      message: 'Tu as dépensé 820 € en 15 jours, soit 41 % de ton revenu.',
      time: '25 juin, 20:00',
      icon: Icons.calendar_today_outlined,
      iconBackground: AppColors.blueLightColor,
      iconColor: AppColors.blueColor,
      isRead: true,
    ),
  ];

  int get unreadNotificationsCount => notifications.where((n) => !n.isRead).length;

  // ---- Dépenses réelles (page Historique + Détail d'une dépense) ----
  // TODO: remplacer par les vraies dépenses ajoutées via le bouton "+" une fois cette page créée.
  List<Expense> expenses = [
    Expense(
      id: '1',
      description: 'Courses de la semaine',
      category: 'Nourriture',
      icon: Icons.shopping_cart_outlined,
      iconBackground: AppColors.blueLightColor,
      date: DateTime(2026, 6, 30),
      amount: 35.00,
    ),
    Expense(
      id: '2',
      description: 'Ticket de bus',
      category: 'Transport',
      icon: Icons.directions_bus_outlined,
      iconBackground: AppColors.greenLightColor,
      date: DateTime(2026, 6, 30),
      amount: 4.50,
    ),
    Expense(
      id: '3',
      description: 'Pharmacie',
      category: 'Santé',
      icon: Icons.medication_outlined,
      iconBackground: AppColors.redLightColor,
      date: DateTime(2026, 6, 29),
      amount: 18.00,
    ),
    Expense(
      id: '4',
      description: 'Cinéma entre amis',
      category: 'Loisirs',
      icon: Icons.movie_outlined,
      iconBackground: AppColors.redLightColor,
      date: DateTime(2026, 6, 29),
      amount: 9.99,
    ),
    Expense(
      id: '5',
      description: "J'ai pris un café court et un croissant",
      category: 'Nourriture',
      icon: Icons.shopping_cart_outlined,
      iconBackground: AppColors.blueLightColor,
      date: DateTime(2026, 6, 27),
      amount: 2.50,
    ),
  ];

  // ---- Budget par catégorie (page Budgets) ----
  // Ancienne liste fixe supprimée : les catégories viennent maintenant de
  // Supabase (catégories par défaut + catégories perso de l'utilisateur),
  // via loadBudgetCategories() ci-dessous.
  final BudgetService _budgetService = BudgetService();
  List<BudgetCategory> budgetCategories = [];
  bool isBudgetLoading = false;

  // Mois actuellement affiché sur la page Budget (toujours le mois en cours
  // pour l'instant, pas de navigation entre les mois).
  final DateTime currentBudgetMonthDate = DateTime(DateTime.now().year, DateTime.now().month, 1);

  Color _hexToColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    final withAlpha = cleaned.length == 6 ? 'ff$cleaned' : cleaned;
    return Color(int.parse(withAlpha, radix: 16));
  }

  /// Charge les catégories (par défaut + perso), le budget déjà enregistré
  /// pour le mois en cours, et les vraies dépenses du mois par catégorie.
  /// À appeler à l'ouverture de la page Budget.
  Future<void> loadBudgetCategories() async {
    isBudgetLoading = true;
    notifyListeners();
    try {
      final categoriesData = await _budgetService.getUserCategories();
      final budgetData = await _budgetService.getBudgetForMonth(currentBudgetMonthDate);
      final spentData = await _budgetService.getSpentForMonth(currentBudgetMonthDate);

      budgetCategories = categoriesData.map((row) {
        final id = row['id'] as int;
        final color = _hexToColor((row['color'] as String?) ?? '#8B5E34');
        return BudgetCategory(
          categoryId: id,
          label: row['name'] as String,
          icon: iconname((row['icon'] as String?) ?? 'category'),
          iconBackground: color.withValues(alpha: 0.15),
          accentColor: color,
          allocated: budgetData[id] ?? 0,
          spent: spentData[id] ?? 0,
        );
      }).toList();

      _checkOverspendNotifications();
    } catch (e) {
      debugPrint('Erreur lors du chargement du budget : $e');
    } finally {
      isBudgetLoading = false;
      notifyListeners();
    }
  }

  /// Sauvegarde le budget actuel (toutes les catégories) pour le mois en
  /// cours dans Supabase.
  Future<void> saveBudgetToSupabase() async {
    final allocations = <int, double>{
      for (final category in budgetCategories)
        if (category.categoryId != null) category.categoryId!: category.allocated,
    };
    await _budgetService.saveBudget(currentBudgetMonthDate, allocations);
  }

  /// Ajoute une notification (dans la liste affichée sur la page
  /// Notifications) pour chaque catégorie qui dépasse son budget, en
  /// évitant les doublons si la notification existe déjà.
  void _checkOverspendNotifications() {
    for (final category in budgetCategories) {
      if (!category.isOverBudget) continue;

      final title = 'Budget ${category.label} dépassé';
      final alreadyNotified = notifications.any((n) => n.title == title);
      if (alreadyNotified) continue;

      notifications.insert(
        0,
        AppNotification(
          title: title,
          message:
              'Tu as dépensé ${category.spent.toStringAsFixed(0)} ${selectedCurrency.symbol} '
              'sur ${category.allocated.toStringAsFixed(0)} ${selectedCurrency.symbol} prévus ce mois-ci.',
          time: 'À l\'instant',
          icon: Icons.warning_amber_rounded,
          iconBackground: AppColors.redLightColor,
          iconColor: AppColors.redColor,
        ),
      );
    }
  }

  double get totalAllocated => budgetCategories.fold(0, (sum, c) => sum + c.allocated);
  double get unallocatedBudget => monthlyIncome - totalAllocated;

  // ---- Setters "profil" : chacun met à jour Supabase EN PLUS de la
  // valeur locale. Si la sauvegarde Supabase échoue, on annule le
  // changement local (rollback) pour ne jamais désynchroniser l'affichage
  // de la vraie base de données, et on relance l'erreur pour que l'écran
  // appelant puisse afficher un message.

  Future<void> updateUserName(String newName) async {
    final previous = userName;
    userName = newName;
    notifyListeners();
    try {
      await _profileService.updateName(newName);
    } catch (e) {
      userName = previous;
      notifyListeners();
      rethrow;
    }
  }

  /// Déclenche une demande de changement d'email. Supabase envoie un lien
  /// de confirmation : l'email affiché ne change réellement qu'après que
  /// l'utilisateur ait cliqué sur ce lien, donc on NE modifie PAS
  /// `userEmail` ici, on relance juste l'erreur en cas de souci.
  Future<void> updateUserEmail(String newEmail) async {
    await _profileService.requestEmailChange(newEmail);
  }

  Future<void> updateMonthlyIncome(double newIncome) async {
    final previous = monthlyIncome;
    monthlyIncome = newIncome;
    notifyListeners();
    try {
      await _profileService.updateRevenuMensuel(newIncome);
    } catch (e) {
      monthlyIncome = previous;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateCurrency(Currency newCurrency) async {
    final previous = selectedCurrency;
    selectedCurrency = newCurrency;
    notifyListeners();
    try {
      await _profileService.updateDevise(newCurrency.code);
    } catch (e) {
      selectedCurrency = previous;
      notifyListeners();
      rethrow;
    }
  }

  /// À appeler juste après un changement de mot de passe réussi
  /// (déjà validé côté Supabase par ProfileService.changePassword).
  void markPasswordUpdated() {
    passwordLastUpdateLabel = 'Dernière modif. à l\'instant';
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    final previous = isDarkMode;
    isDarkMode = value;
    notifyListeners();
    try {
      await _profileService.updateModeSombre(value);
    } catch (e) {
      isDarkMode = previous;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> setNotificationsOn(bool value) async {
    final previous = notificationsOn;
    notificationsOn = value;
    notifyListeners();
    try {
      await _profileService.updateNotifications(value);
    } catch (e) {
      notificationsOn = previous;
      notifyListeners();
      rethrow;
    }
  }

  void markAllNotificationsRead() {
    notifications = notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  void markNotificationRead(int index) {
    notifications[index] = notifications[index].copyWith(isRead: true);
    notifyListeners();
  }

  // ---- Gestion des dépenses ----

  void deleteExpense(String id) {
    expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void updateExpense(String id, {String? description, String? category, DateTime? date}) {
    final expense = expenses.firstWhere((e) => e.id == id);
    if (description != null) expense.description = description;
    if (category != null) expense.category = category;
    if (date != null) expense.date = date;
    notifyListeners();
  }

  // ---- Gestion du budget ----

  void updateBudgetAllocation(String label, double newAmount) {
    final category = budgetCategories.firstWhere((c) => c.label == label);
    category.allocated = newAmount;
    notifyListeners();
  }

  // Applique un preset de répartition en une fois (ex: bouton "Économe")
  void applyBudgetPreset(Map<String, double> preset) {
    for (final category in budgetCategories) {
      if (preset.containsKey(category.label)) {
        category.allocated = preset[category.label]!;
      }
    }
    notifyListeners();
  }
}