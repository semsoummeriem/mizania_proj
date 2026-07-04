import 'package:flutter/material.dart';
import 'fonts.dart';
import 'colors.dart';

class AppStyles {
  static const TextStyle bigtextstyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle smalltextstyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w100,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
    letterSpacing: 0.5,
  );
  static const TextStyle labelStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
}
