import 'package:flutter/material.dart';
import 'package:mizania_proj/core/constants/colors.dart';
import 'package:mizania_proj/core/constants/styles.dart';
import 'package:mizania_proj/features/screens/profile/widgets/AppBackground.dart';
import 'package:mizania_proj/core/widgets/input_fields.dart';
import 'package:mizania_proj/models/category.dart';
import 'package:mizania_proj/core/services/supabase_client.dart';
import 'package:mizania_proj/core/constants/icon_map.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final List<Color> colorOptions = [
    Colors.indigo,
    Colors.deepPurpleAccent,
    Colors.lightBlue,
    Colors.pinkAccent,
    Colors.orange,
  ];

  Color chosenColor = Colors.indigo;

  final List<IconData> iconOptions = [
    Icons.home,
    Icons.card_giftcard,
    Icons.fastfood,
    Icons.calendar_today,
    Icons.directions_car,
  ];

  IconData chosenIcon = Icons.home;
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.initialAmount != null) {
  //     amount = widget.initialAmount!;
  //     amountController.text = amount.toStringAsFixed(2);
  //   }
  //   if (widget.initialCategory != null) {
  //     SelectedCategory = widget.initialCategory;
  //   }
  //   if (widget.initialDate != null) {
  //     SelectedDate = widget.initialDate!;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkmauveColor,
        title: Text('Ajouter une catégory'),
      ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Container(
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                        //padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.dotColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.dotColor,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: AppColors.backgrounddarkColor.withValues(
                                alpha: 0.2,
                              ),
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(chosenIcon, size: 40, color: chosenColor),
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
                    Text(
                      'NOM',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Nourriture',
                        hintStyle: TextStyle(
                          fontSize: 10,
                          fontFamily: 'PlusJakartaSans',
                          color: AppColors.smalltextColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppColors.dotColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.dotColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'ICONE',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 4,
                      children: iconOptions.map((icon) {
                        bool isSelected = chosenIcon == icon;
                        return GestureDetector(
                          onTap: () => setState(() => chosenIcon = icon),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.dotColor
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                icon,
                                color: AppColors.dotColor,
                                size: 24,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24),
                    SizedBox(height: 24),
                    Text(
                      'COULEUR',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: colorOptions.map((color) {
                        bool isSelected = chosenColor == color;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () => setState(() => chosenColor = color),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: Colors.black, width: 2)
                                    : null,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Merci d\'entrer un nom')),
                      );
                      return;
                    }
                    final userID = supabase.auth.currentUser!.id;
                    final colorHex =
                        '#${chosenColor.value.toRadixString(16).substring(2)}';

                    final inserted = await supabase
                        .from('categories')
                        .insert({
                          'user_id': userID,
                          'name': nameController.text.trim(),
                          'icon': renameIcon(chosenIcon),
                          'color': colorHex,
                          'is_default': false,
                        })
                        .select()
                        .single();
                    Navigator.pop(
                      context,
                      Category(
                        icon: chosenIcon,
                        name: inserted['name'],
                        color: inserted['color'],
                        id: inserted['id'],
                        isDefault: false,
                      ),
                    );
                  },
                  icon: Icon(Icons.check, color: Colors.white),
                  label: Text(
                    'Enregistrer la categorie',
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
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
