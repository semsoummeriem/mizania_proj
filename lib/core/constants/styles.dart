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

  // --- Ajouts pour email / mot de passe / revenu ---
  static const TextStyle infoBoxTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.amberColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle strengthLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.greenColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.roseColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle budgetImpactTitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.darkmauveColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle budgetImpactRowStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.darkmauveColor,
    fontFamily: AppFonts.plusJakartaSans,
  );

  // --- Ajouts pour la page Home ---
  static const TextStyle greetingStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle greetingNameStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle totalLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle totalAmountStyle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle cardSectionTitleStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle linkStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.darkmauveColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle incomeAmountStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.darkmauveColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle remainingStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.amberColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle percentUsedStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle legendLabelStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle legendAmountStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle expenseAmountStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );

  // --- Ajouts pour la page Notifications ---
  static const TextStyle notifTitleStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle notifMessageStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle notifTimeStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );

  // --- Ajout de ta copine ---
  static const TextStyle LinkbuttonTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.dotColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
}