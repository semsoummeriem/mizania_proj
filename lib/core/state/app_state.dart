import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/icon_map.dart';
import '../../features/screens/profile/currency_model.dart';
import '../services/profile_service.dart';
import '../services/budget_service.dart';
import '../services/home_service.dart';
import '../services/notification_service.dart';
import '../services/prediction_service.dart';

const List<String> kFrenchMonthNames = [
  'janvier',
  'février',
  'mars',
  'avril',
  'mai',
  'juin',
  'juillet',
  'août',
  'septembre',
  'octobre',
  'novembre',
  'décembre',
];

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

class BudgetCategory {
  final int? categoryId;
  final String label;
  final IconData icon;
  final Color iconBackground;
  final Color accentColor;
  double allocated;
  double spent;

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

class AppNotification {
  final int? id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final bool isRead;

  const AppNotification({
    this.id,
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
      id: id,
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

class AppState extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final PredictionService _predictionService = PredictionService();

  /// Réinitialise tout l'état en mémoire aux valeurs par défaut.
  /// À appeler OBLIGATOIREMENT lors de la déconnexion, pour éviter
  /// qu'un nouvel utilisateur voie encore les données de l'ancien.
  void reset() {
    userName = '...';
    userEmail = '...';
    monthlyIncome = 0;
    selectedCurrency = availableCurrencies.first;
    passwordLastUpdateLabel = '...';
    isDarkMode = false;
    notificationsOn = false;
    expensesCount = 0;
    monthsFollowed = 0;
    isProfileLoading = false;

    totalSpentThisMonth = 0;
    categoryBreakdown = [];
    recentExpenses = [];
    isHomeLoading = false;

    notifications = [];

    budgetCategories = [];
    isBudgetLoading = false;

    notifyListeners();
  }

  // ---- Profil utilisateur ----
  String userName = '...';
  String userEmail = '...';
  double monthlyIncome = 0;
  Currency selectedCurrency = availableCurrencies.first;
  String passwordLastUpdateLabel = '...';
  bool isDarkMode = false;
  bool notificationsOn = false;

  int expensesCount = 0;
  int monthsFollowed = 0;

  bool isProfileLoading = false;

  Future<void> _syncPredictionNotification() async {
    try {
      final prediction = await _predictionService.getPrediction();

      if (prediction['prediction_available'] == true) {
        final amount = prediction['predicted_amount'] as double;
        final title = 'Prédiction du mois';
        final message =
            'Vous allez probablement dépenser environ '
            '${amount.toStringAsFixed(0)} ${selectedCurrency.symbol} ce mois-ci.';

        await _notificationService.upsertPredictionNotification(
          month: currentBudgetMonthDate,
          title: title,
          message: message,
        );
      } else {
        await _notificationService.deletePredictionNotification(
          month: currentBudgetMonthDate,
        );
      }
    } catch (e) {
      debugPrint('Erreur de synchronisation de la prédiction : $e');
    }
  }

  Future<void> loadProfile() async {
    isProfileLoading = true;
    notifyListeners();
    try {
      final data = await _profileService.getFullProfile();

      userName = (data['name'] as String?) ?? userName;
      userEmail = (data['email'] as String?) ?? userEmail;
      monthlyIncome =
          (data['revenu_mensuel'] as num?)?.toDouble() ?? monthlyIncome;

      final currencyCode = data['devise'] as String?;
      if (currencyCode != null) {
        selectedCurrency = availableCurrencies.firstWhere(
          (c) => c.code == currencyCode,
          orElse: () => selectedCurrency,
        );
      }

      isDarkMode = (data['mode_sombre'] as bool?) ?? isDarkMode;
      notificationsOn =
          (data['notifications_actives'] as bool?) ?? notificationsOn;
      expensesCount = (data['expenses_count'] as int?) ?? 0;
      monthsFollowed = (data['months_followed'] as int?) ?? 0;
      passwordLastUpdateLabel = _formatPasswordLabel(
        data['password_updated_at'] as String?,
      );
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
  final HomeService _homeService = HomeService();
  bool isHomeLoading = false;

  double totalSpentThisMonth = 0;
  List<CategoryAmount> categoryBreakdown = [];
  List<ExpenseItem> recentExpenses = [];

  String get currentMonthLabel {
    final monthName = kFrenchMonthNames[currentBudgetMonthDate.month - 1];
    final capitalized = monthName[0].toUpperCase() + monthName.substring(1);
    return '$capitalized ${currentBudgetMonthDate.year}';
  }

  Future<void> loadHomeData() async {
    isHomeLoading = true;
    notifyListeners();
    try {
      final breakdownData = await _homeService.getCategoryBreakdown(
        currentBudgetMonthDate,
      );
      final recentData = await _homeService.getRecentExpenses(limit: 3);

      categoryBreakdown = breakdownData.map((row) {
        return CategoryAmount(
          label: row['name'] as String,
          amount: (row['amount'] as num).toDouble(),
          color: _hexToColor((row['color'] as String?) ?? '#8B5E34'),
        );
      }).toList()..sort((a, b) => b.amount.compareTo(a.amount));

      totalSpentThisMonth = categoryBreakdown.fold(
        0,
        (sum, c) => sum + c.amount,
      );

      recentExpenses = recentData.map((row) {
        final category = row['categories'] as Map<String, dynamic>?;
        final date = DateTime.parse(row['date'] as String);
        final color = _hexToColor((category?['color'] as String?) ?? '#8B5E34');
        return ExpenseItem(
          category: (category?['name'] as String?) ?? 'Autres',
          date: _formatShortDate(date),
          amount: (row['amount'] as num?)?.toDouble() ?? 0,
          icon: iconname((category?['icon'] as String?) ?? 'category'),
          iconBackground: color.withValues(alpha: 0.15),
        );
      }).toList();
      await _syncPredictionNotification();
      await loadNotifications();
    } catch (e) {
      debugPrint('Erreur lors du chargement de la Home : $e');
    } finally {
      isHomeLoading = false;
      notifyListeners();
    }
  }

  String _formatShortDate(DateTime date) {
    return '${date.day} ${kFrenchMonthNames[date.month - 1]}';
  }

  // ---- Notifications ----
  final NotificationService _notificationService = NotificationService();
  List<AppNotification> notifications = [];

  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  IconData _iconForNotificationType(String type) {
    switch (type) {
      case 'budget_overspend':
        return Icons.warning_amber_rounded;
      case 'prediction':
        return Icons.trending_up_rounded;
      default:
        return Icons.notifications_none;
    }
  }

  Color _iconBackgroundForNotificationType(String type) {
    switch (type) {
      case 'budget_overspend':
        return AppColors.redLightColor;
      case 'prediction':
        return AppColors.blueLightColor;
      default:
        return AppColors.purpleLightColor;
    }
  }

  Color _iconColorForNotificationType(String type) {
    switch (type) {
      case 'budget_overspend':
        return AppColors.redColor;
      case 'prediction':
        return AppColors.darkmauveColor;
      default:
        return AppColors.darkmauveColor;
    }
  }

  String _formatNotificationTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    if (diff.inDays == 1) return 'Hier';
    return _formatShortDate(date);
  }

  Future<void> loadNotifications() async {
    try {
      final rows = await _notificationService.getNotifications();
      notifications = rows.map((row) {
        final type = row['type'] as String? ?? 'budget_overspend';
        return AppNotification(
          id: row['id'] as int,
          title: row['title'] as String,
          message: row['message'] as String,
          time: _formatNotificationTime(
            DateTime.parse(row['created_at'] as String),
          ),
          icon: _iconForNotificationType(type),
          iconBackground: _iconBackgroundForNotificationType(type),
          iconColor: _iconColorForNotificationType(type),
          isRead: row['is_read'] as bool? ?? false,
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement des notifications : $e');
    }
  }

  // ---- Dépenses réelles ----
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

  // ---- Budget par catégorie ----
  final BudgetService _budgetService = BudgetService();
  List<BudgetCategory> budgetCategories = [];
  bool isBudgetLoading = false;

  final DateTime currentBudgetMonthDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  Color _hexToColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    final withAlpha = cleaned.length == 6 ? 'ff$cleaned' : cleaned;
    return Color(int.parse(withAlpha, radix: 16));
  }

  Future<void> loadBudgetCategories() async {
    isBudgetLoading = true;
    notifyListeners();
    try {
      final categoriesData = await _budgetService.getUserCategories();
      final budgetData = await _budgetService.getBudgetForMonth(
        currentBudgetMonthDate,
      );
      final spentData = await _budgetService.getSpentForMonth(
        currentBudgetMonthDate,
      );

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

      await _syncOverspendNotifications();
    } catch (e) {
      debugPrint('Erreur lors du chargement du budget : $e');
    } finally {
      isBudgetLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveBudgetToSupabase() async {
    final allocations = <int, double>{
      for (final category in budgetCategories)
        if (category.categoryId != null)
          category.categoryId!: category.allocated,
    };
    await _budgetService.saveBudget(currentBudgetMonthDate, allocations);
  }

  Future<void> _syncOverspendNotifications() async {
    for (final category in budgetCategories) {
      if (category.categoryId == null) continue;

      try {
        if (category.isOverBudget) {
          final title = 'Budget ${category.label} dépassé';
          final message =
              'Tu as dépensé ${category.spent.toStringAsFixed(0)} ${selectedCurrency.symbol} '
              'sur ${category.allocated.toStringAsFixed(0)} ${selectedCurrency.symbol} prévus ce mois-ci.';

          await _notificationService.upsertBudgetOverspendNotification(
            categoryId: category.categoryId!,
            month: currentBudgetMonthDate,
            title: title,
            message: message,
          );
        } else {
          await _notificationService.deleteBudgetOverspendNotification(
            categoryId: category.categoryId!,
            month: currentBudgetMonthDate,
          );
        }
      } catch (e) {
        debugPrint(
          'Erreur de synchronisation de la notification (${category.label}) : $e',
        );
      }
    }

    await loadNotifications();
  }

  double get totalAllocated =>
      budgetCategories.fold(0, (sum, c) => sum + c.allocated);
  double get unallocatedBudget => monthlyIncome - totalAllocated;

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

  Future<void> markAllNotificationsRead() async {
    final previous = List<AppNotification>.from(notifications);
    notifications = notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
    try {
      await _notificationService.markAllAsRead();
    } catch (e) {
      notifications = previous;
      notifyListeners();
    }
  }

  Future<void> markNotificationRead(int index) async {
    final notification = notifications[index];
    if (notification.isRead || notification.id == null) return;

    notifications[index] = notification.copyWith(isRead: true);
    notifyListeners();
    try {
      await _notificationService.markAsRead(notification.id!);
    } catch (e) {
      notifications[index] = notification;
      notifyListeners();
    }
  }

  // ---- Gestion des dépenses ----
  void deleteExpense(String id) {
    expenses.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void updateExpense(
    String id, {
    String? description,
    String? category,
    DateTime? date,
  }) {
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

  void applyBudgetPreset(Map<String, double> preset) {
    for (final category in budgetCategories) {
      if (preset.containsKey(category.label)) {
        category.allocated = preset[category.label]!;
      }
    }
    notifyListeners();
  }
}
