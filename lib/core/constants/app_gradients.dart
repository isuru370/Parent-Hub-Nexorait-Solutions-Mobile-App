import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppGradients {

  /// Main Brand Gradient
  static const LinearGradient primaryGradient =
      LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryBlue,
      AppColors.darkBlue,
    ],
  );

  /// Orange Gold Gradient
  static const LinearGradient accentGradient =
      LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryOrange,
      AppColors.primaryGold,
    ],
  );

  /// Dashboard Gradient
  static const LinearGradient dashboardGradient =
      LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryBlue,
      AppColors.primaryOrange,
    ],
  );
}