import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../../features/screens/profile/currency_model.dart';

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
  final String label;
  final IconData icon;
  final Color iconBackground;
  final Color accentColor;
  double allocated;

  BudgetCategory({
    required this.label,
    required this.icon,
    required this.iconBackground,
    required this.accentColor,
    required this.allocated,
  });
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
  // ---- Profil utilisateur ----
  String userName = 'Yacine Amrani';
  String userEmail = 'yacine.amrani@gmail.com';
  double monthlyIncome = 2000;
  Currency selectedCurrency = availableCurrencies.first;
  String passwordLastUpdateLabel = 'Dernière modif. il y a 3 mois';
  bool isDarkMode = false;
  bool notificationsOn = false;

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
  List<BudgetCategory> budgetCategories = [
    BudgetCategory(
      label: 'Nourriture',
      icon: Icons.shopping_cart_outlined,
      iconBackground: AppColors.blueLightColor,
      accentColor: AppColors.amberColor,
      allocated: 400,
    ),
    BudgetCategory(
      label: 'Transport',
      icon: Icons.directions_bus_outlined,
      iconBackground: AppColors.greenLightColor,
      accentColor: AppColors.blueColor,
      allocated: 150,
    ),
    BudgetCategory(
      label: 'Logement',
      icon: Icons.home_outlined,
      iconBackground: AppColors.greenLightColor,
      accentColor: AppColors.greenColor,
      allocated: 500,
    ),
    BudgetCategory(
      label: 'Loisirs',
      icon: Icons.movie_outlined,
      iconBackground: AppColors.redLightColor,
      accentColor: AppColors.darkmauveColor,
      allocated: 200,
    ),
    BudgetCategory(
      label: 'Santé',
      icon: Icons.medication_outlined,
      iconBackground: AppColors.orangeLightColor,
      accentColor: Color(0xFF8B5E34),
      allocated: 100,
    ),
    BudgetCategory(
      label: 'Autres',
      icon: Icons.inventory_2_outlined,
      iconBackground: AppColors.purpleLightColor,
      accentColor: AppColors.darkmauveColor,
      allocated: 120,
    ),
  ];

  double get totalAllocated => budgetCategories.fold(0, (sum, c) => sum + c.allocated);
  double get unallocatedBudget => monthlyIncome - totalAllocated;

  // ---- Setters : chacun modifie une valeur PUIS appelle notifyListeners() ----
  // C'est ce notifyListeners() qui déclenche la mise à jour automatique de
  // toutes les pages qui affichent cette donnée.

  void updateUserName(String newName) {
    userName = newName;
    notifyListeners();
  }

  void updateUserEmail(String newEmail) {
    userEmail = newEmail;
    notifyListeners();
  }

  void updateMonthlyIncome(double newIncome) {
    monthlyIncome = newIncome;
    notifyListeners();
  }

  void updateCurrency(Currency newCurrency) {
    selectedCurrency = newCurrency;
    notifyListeners();
  }

  void markPasswordUpdated() {
    passwordLastUpdateLabel = 'Dernière modif. à l\'instant';
    notifyListeners();
  }

  void setDarkMode(bool value) {
    isDarkMode = value;
    notifyListeners();
  }

  void setNotificationsOn(bool value) {
    notificationsOn = value;
    notifyListeners();
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