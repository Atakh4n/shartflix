import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFFE53E3E);
  static const Color primaryDark = Color(0xFFD53030);
  static const Color primaryLight = Color(0xFFFF5A5A);

  // Background Colors
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color surfaceVariant = Color(0xFF2D2D2D);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textTertiary = Color(0xFF666666);

  // Input Colors
  static const Color inputBackground = Color(0xFF2D2D2D);
  static const Color inputBorder = Color(0xFF6B46C1);
  static const Color inputBorderActive = Color(0xFF8B5CF6);
  static const Color inputText = Color(0xFFFFFFFF);
  static const Color inputHint = Color(0xFF9CA3AF);

  // Button Colors
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = Color(0xFF374151);
  static const Color buttonDisabled = Color(0xFF4B5563);

  // Social Login Colors
  static const Color google = Color(0xFF4285F4);
  static const Color apple = Color(0xFF000000);
  static const Color facebook = Color(0xFF1877F2);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Card Colors
  static const Color cardBackground = Color(0xFF1F1F1F);
  static const Color cardBorder = Color(0xFF374151);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFFE53E3E),
    Color(0xFFFF5A5A),
  ];

  static const List<Color> backgroundGradient = [
    Color(0xFF000000),
    Color(0xFF1A1A1A),
  ];

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x33000000);

  // Divider Colors
  static const Color divider = Color(0xFF374151);
  static const Color dividerLight = Color(0xFF4B5563);
}