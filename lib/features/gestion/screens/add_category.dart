import 'package:flutter/material.dart';
import 'package:mizania_proj/core/constants/colors.dart';
import 'package:mizania_proj/core/constants/styles.dart';
import 'package:mizania_proj/features/screens/profile/widgets/AppBackground.dart';
import 'package:mizania_proj/core/widgets/input_fields.dart';
import 'package:mizania_proj/models/category.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  IconData chosenIcon = Icons.hourglass_empty;

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
                        alignment: Alignment.center,
                        //padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.dotColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: AppColors.backgrounddarkColor.withValues(
                                alpha: 1,
                              ),
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(chosenIcon),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
