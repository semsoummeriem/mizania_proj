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
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );

  // --- Ajouts pour la page Profil ---
  static const TextStyle profileNameStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.whiteColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle profileEmailStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.whiteColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle tileTitleStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle tileSubtitleStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle statNumberStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle statLabelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
    fontFamily: AppFonts.plusJakartaSans,
  );

  // --- Ajouts pour les pages "Modifier ..." (nom, email, mot de passe, revenu) ---
  static const TextStyle editAppBarTitleStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.whiteColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle fieldLabelStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle helperTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );

  static const TextStyle LinkbuttonTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.dotColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
}