import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceVariant = Color(0xFF1A2236);

  // Neon accents
  static const Color neonCyan = Color(0xFF00F0FF);
  static const Color neonBlue = Color(0xFF3B82F6);
  static const Color neonPurple = Color(0xFF8B5CF6);
  static const Color neonGreen = Color(0xFF10B981);
  static const Color neonPink = Color(0xFFEC4899);

  // Semantic
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Text
  static const Color textPrimary = Color(0xFFE2E8F0);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Border
  static const Color border = Color(0xFF1E293B);

  // Gradients
  static const LinearGradient appBarGradient = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF1A1040)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient progressGradient = LinearGradient(
    colors: [Color(0xFF00F0FF), Color(0xFF3B82F6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
