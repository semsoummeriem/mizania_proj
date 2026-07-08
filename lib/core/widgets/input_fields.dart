import 'package:flutter/material.dart';
import 'package:mizania_proj/core/constants/colors.dart';
import 'package:mizania_proj/core/constants/styles.dart';

class InputField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool isPassword;

  const InputField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.isPassword = false,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppStyles.labelStyle,
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.whiteColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: AppColors.smalltextColor,
              fontFamily: 'PlusJakartaSans',
              fontSize: 10,
              fontWeight: FontWeight.w200,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.smalltextColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
