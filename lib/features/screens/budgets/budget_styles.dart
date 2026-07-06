import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';

/// Styles utilisés uniquement par la page Budget.
class BudgetStyles {
  static const TextStyle headerTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle incomeLabelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.whiteColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle incomeAmountStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.amberColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle unallocatedLabelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle unallocatedAmountStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.greenColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle sectionTitleStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle presetTitleStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle presetSubtitleStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle categoryLabelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle totalLabelStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle totalValueStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.greenColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle noteStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle saveButtonStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.whiteColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
}