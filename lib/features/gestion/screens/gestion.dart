import 'package:flutter/material.dart';
import 'package:mizania_proj/core/constants/colors.dart';
import 'package:mizania_proj/core/constants/styles.dart';
import 'package:mizania_proj/features/screens/profile/widgets/AppBackground.dart';
import 'package:mizania_proj/core/widgets/input_fields.dart';
import 'package:mizania_proj/models/category.dart';
import 'add_category.dart';
import 'package:mizania_proj/core/widgets/custom_bottom_nav_bar.dart';
import 'package:mizania_proj/core/services/supabase_client.dart';
import 'package:mizania_proj/core/services/expense_service.dart';
import 'package:mizania_proj/core/constants/icon_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Gestion extends StatefulWidget {
  final double? initialAmount;
  final String? initialCategory;
  final DateTime? initialDate;

  const Gestion({
    super.key,
    this.initialAmount,
    this.initialCategory,
    this.initialDate,
  });

  @override
  State<Gestion> createState() => _GestionState();
}

class _GestionState extends State<Gestion> {
  String _formatDate(DateTime date) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  List<Category> categories = [];

  bool _loadingCategories = true;

  final _ExpenseService = ExpenseService();

  double amount = 0.00;
  String? SelectedCategory;
  DateTime SelectedDate = DateTime.now();
  int? SelectedCategoryID;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool _showConfirmation = false;
  bool _finishInsertingExpense = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialAmount != null) {
      amount = widget.initialAmount!;
      amountController.text = amount.toStringAsFixed(2);
    }
    if (widget.initialCategory != null) {
      SelectedCategory = widget.initialCategory;
    }
    if (widget.initialDate != null) {
      SelectedDate = widget.initialDate!;
    }
  }

  Future<void> loadCategories() async {
    final userID = supabase.auth.currentUser!.id;
    final data = await supabase
        .from('categories')
        .select()
        .or('user_id.is.null, user_id.eq.$userID');
    setState(() {
      categories = (data as List).map((row) {
        return Category(
          id: row['id'],
          icon: iconname(row['icon']),
          name: row['name'],
          color: row['color'],
          isDefault: row['is_default'] ?? false,
        );
      }).toList();
      _loadingCategories = false;
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundlightColor,
      body: AppBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 260,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 1.0,
                        child: Image.asset(
                          'assets/home_icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.initialAmount != null
                                ? "Modifier la dépense"
                                : "Ajouter une dépense",
                            style: AppStyles.labelStyle,
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.black.withValues(alpha: 0.05),
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Montant actuel',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                IntrinsicWidth(
                                  child: TextField(
                                    controller: amountController,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      hintText: "0.00 €",
                                      hintStyle: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      suffixText: "€",
                                      suffixStyle: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        amount = double.tryParse(value) ?? 0.00;
                                      });
                                    },
                                    onEditingComplete: () {
                                      setState(() {
                                        amountController.text = amount
                                            .toStringAsFixed(2);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    InputField(
                      label: 'Description',
                      hint: 'ex: Café...',
                      controller: descriptionController,
                    ),
                    SizedBox(height: 24),
                    Text('Catégorie', style: AppStyles.labelStyle),
                    SizedBox(height: 8),
                    _loadingCategories
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(18),
                              child: SpinKitFadingCircle(
                                color: AppColors.dotColor,
                                size: 50.0,
                              ),
                            ),
                          )
                        : GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 4,
                            children: [
                              ...categories.map((category) {
                                bool isSelected =
                                    SelectedCategory == category.name;
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    SelectedCategory = category.name;
                                    SelectedCategoryID = category.id;
                                  }),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.dotColor.withValues(
                                              alpha: 0.3,
                                            )
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.backgrounddarkColor
                                            : Colors.white,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          category.icon,
                                          size: 16,
                                          color: isSelected
                                              ? Colors.white
                                              : AppColors.dotColor,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          category.name,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : AppColors.backgrounddarkColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              GestureDetector(
                                onTap: () async {
                                  final newCat = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddCategory(),
                                    ),
                                  );
                                  if (newCat != null) {
                                    setState(() {
                                      categories.add(newCat);
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppColors.backgrounddarkColor,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 16,
                                        color: AppColors.dotColor,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Ajouter',
                                        style: TextStyle(
                                          color: AppColors.dotColor,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(height: 24),
                    Text('Date', style: AppStyles.labelStyle),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: SelectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            SelectedDate = pickedDate;
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.backgrounddarkColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(SelectedDate),
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.backgrounddarkColor,
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: AppColors.dotColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          //inal amount = amountController.n;
                          // actual save logic
                          if (amount <= 0.00 || SelectedCategoryID == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Merci de remplir tous les champs',
                                ),
                              ),
                            );
                            return;
                          }
                          try {
                            await _ExpenseService.addExpense(
                              amount: amount,
                              description: descriptionController.text,
                              categoryId: SelectedCategoryID!,
                              date: SelectedDate,
                            );
                            setState(() {
                              _showConfirmation = true;
                              _finishInsertingExpense = true;
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erreur: $e')),
                            );
                          }
                        },
                        icon: Icon(Icons.check, color: Colors.white),
                        label: Text(
                          widget.initialAmount != null
                              ? 'Enregistrer les modifications'
                              : 'Confirmer le budget',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.dotColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    if (!_finishInsertingExpense)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: SpinKitDancingSquare(
                            color: AppColors.dotColor,
                            size: 50.0,
                          ),
                        ),
                      ),
                    if (_showConfirmation && _finishInsertingExpense)
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 16),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.initialAmount != null
                                    ? 'Dépense modifiée avec succès !'
                                    : 'Dépense ajoutée avec succès !',
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1,
        onTap: (index) {
          Navigator.pop(context, index);
        },
        onAddTap: () {},
      ),
    );
  }
}
