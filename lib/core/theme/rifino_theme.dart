import 'package:flutter/material.dart';
import 'package:rifino/core/theme/rifino_colors.dart';
import 'package:rifino/core/theme/rifino_spacing.dart';

abstract final class RifinoTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: RifinoColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: RifinoColors.background,
      fontFamily: null,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: RifinoColors.background,
        foregroundColor: RifinoColors.textPrimary,
        titleTextStyle: TextStyle(
          color: RifinoColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: base.textTheme.copyWith(
        headlineLarge: const TextStyle(
          color: RifinoColors.primaryDark,
          fontSize: 34,
          fontWeight: FontWeight.w900,
        ),
        headlineMedium: const TextStyle(
          color: RifinoColors.textPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w900,
        ),
        titleMedium: const TextStyle(
          color: RifinoColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
        bodyLarge: const TextStyle(
          color: RifinoColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: const TextStyle(
          color: RifinoColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RifinoColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: RifinoSpacing.md,
          vertical: RifinoSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RifinoRadius.lg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RifinoRadius.lg),
          borderSide: const BorderSide(color: RifinoColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RifinoRadius.lg),
          borderSide: const BorderSide(color: RifinoColors.accentBlue, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RifinoRadius.lg),
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? RifinoColors.accent
              : Colors.white,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? RifinoColors.accent.withValues(alpha: 0.32)
              : RifinoColors.surfaceMuted,
        ),
      ),
    );
  }

}
