import 'package:flutter/material.dart';
import 'package:glowbebe/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLarge = GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    height: 1.1,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 1.15,
    color: AppColors.textPrimary,
  );

  static TextStyle displaySmall = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.33,
    color: AppColors.textPrimary,
  );

  static TextStyle headingLarge = GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static TextStyle headingMedium = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLarge = GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static TextStyle label = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 2.4,
    height: 1.33,
    color: Colors.white,
  );

  static TextStyle navLabel = GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.7,
    height: 1.43,
    color: AppColors.primary,
  );

  static TextStyle caption = GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.primary,
  );
}
