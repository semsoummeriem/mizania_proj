import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';

/// Styles utilisés uniquement par la page Historique et sa page de détail.
class HistoriqueStyles {
  static const TextStyle monthLabelStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle statLabelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: AppColors.smalltextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle statValueStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle dateSectionStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.darkmauveColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle expenseCategoryStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.bigtextColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle expenseAmountStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.roseColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle detailButtonStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
    fontFamily: AppFonts.plusJakartaSans,
  );
  static const TextStyle filterChipStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    fontFamily: AppFonts.plusJakartaSans,
  );
}