import 'package:flutter/material.dart';

class AppTypography {
  static const String _fontFamily = 'Inter';
  static const String _documentFontFamily = 'Source Serif';
  
  // Light theme text styles
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: _fontFamily,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: _fontFamily,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: _fontFamily,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: _fontFamily,
    color: AppColors.white,
    height: 1.2,
  );
  
  // Document preview text style
  static const TextStyle documentPreview = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: _documentFontFamily,
    color: AppColors.textPrimary,
    height: 1.6,
  );
  
  // Dark theme text styles
  static const TextStyle darkH1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: _fontFamily,
    color: AppColors.darkTextPrimary,
  );
  
  static const TextStyle darkBody1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: _fontFamily,
    color: AppColors.darkTextPrimary,
    height: 1.5,
  );
  
  static const TextStyle darkDocumentPreview = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: _documentFontFamily,
    color: AppColors.darkTextPrimary,
    height: 1.6,
  );
}