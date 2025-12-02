import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Rubik Font Styles
  static TextStyle rubikRegular(double fontSize, Color color) {
    return GoogleFonts.rubik(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle rubikMedium(double fontSize, Color color) {
    return GoogleFonts.rubik(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle rubikSemiBold(double fontSize, Color color) {
    return GoogleFonts.rubik(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle rubikBold(double fontSize, Color color) {
    return GoogleFonts.rubik(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  // Nunito Sans Font Styles
  static TextStyle nunitoRegular(double fontSize, Color color) {
    return GoogleFonts.nunitoSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle nunitoBold(double fontSize, Color color) {
    return GoogleFonts.nunitoSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  static TextStyle nunitoExtraBold(double fontSize, Color color) {
    return GoogleFonts.nunitoSans(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      color: color,
      letterSpacing: 0.009375,
    );
  }

  // Airbnb Cereal Font Styles
  static TextStyle airbnbCerealBold(double fontSize, Color color) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: -0.025,
    );
  }
  static const TextStyle smallLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  
  // Specific Text Styles from Figma
  static TextStyle get splashTitle => rubikSemiBold(24, AppColors.textWhite)
      .copyWith(height: 1.69, letterSpacing: 0);
  
  static TextStyle get splashSubtitle => rubikRegular(16, AppColors.textWhite)
      .copyWith(height: 1.69);
  
  static TextStyle get buttonText => rubikMedium(14, AppColors.textPrimary)
      .copyWith(height: 1.08, letterSpacing: 0.05);
  
  static TextStyle get sectionTitle => rubikSemiBold(16, AppColors.textLight)
      .copyWith(height: 1.5);
  
  static TextStyle get habitTitle => nunitoExtraBold(16, AppColors.textWhite)
      .copyWith(height: 1.36, letterSpacing: 0.009375);
  
  static TextStyle get habitInfo => nunitoRegular(12, AppColors.textWhite)
      .copyWith(height: 1.33, letterSpacing: 0.0333);
  
  static TextStyle get pageTitle => rubikMedium(24, AppColors.textWhite)
      .copyWith(height: 1.185);
  
  static TextStyle get welcomeTitle => rubikBold(28, AppColors.textPrimary)
      .copyWith(height: 1.35);
  
  static TextStyle get inputLabel => rubikRegular(16, AppColors.textSecondary)
      .copyWith(height: 1.08, letterSpacing: 0.05);
  
  static TextStyle get profileName => rubikBold(16, AppColors.textPrimary)
      .copyWith(height: 0.875, letterSpacing: -0.03);
  
  static TextStyle get profileId => rubikMedium(12, AppColors.textPrimary)
      .copyWith(height: 1.17, letterSpacing: -0.03, color: AppColors.textPrimary.withValues(alpha: 0.5));
  
  static TextStyle get settingsItem => rubikMedium(18.43, AppColors.textWhite)
      .copyWith(height: 1.185);
  
  static TextStyle get dayLabel => rubikRegular(12, AppColors.textBlack)
      .copyWith(height: 1.5);
}

