import 'package:flutter/material.dart';
import 'package:mizania_proj/core/constants/colors.dart';
import 'package:mizania_proj/core/constants/styles.dart';


class InputField extends StatelessWidget {
  final String label;
  final String hint;
  const InputField({super.key, required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
                label,
                style: AppStyles.labelStyle,
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 6),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  hintText: hint,
                  hintStyle: TextStyle(color: AppColors.smalltextColor,
                                       fontFamily: 'PlusJakartaSans',
                                       fontSize: 10,
                                       fontWeight: FontWeight.w200),
                  ),
                ),
      ],
    );
  }
}