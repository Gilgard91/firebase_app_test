import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppColors {
  static const LinearGradient textPrimary = LinearGradient(
    colors: [
      Color(0xFF888BF4),
      Color(0xFF5151C6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient textSecondary = LinearGradient(
    colors: [
      Color(0xFF7F7FCA),
      Color(0xFFDFE0FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color secondary = Color(0xFFFF9800);
  static const Color background = Color(0xFFF5F5F5);
  static const Color error = Color(0xFFD32F2F);

  static const LinearGradient inputBackground = LinearGradient(
    colors: [
      Color(0xFFF8F8F8),
      Color(0xFFEFEFEF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}