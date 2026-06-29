import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppColors {
  static const primary = Color(0xFF000000);
  static const primaryContainer = Color(0xFF131B2E);
  static const onPrimaryContainer = Color(0xFF8C939B);
  static const inversePrimary = Color(0xFFBEC6E0);

  static const secondary = Color(0xFF0051D5);
  static const secondaryContainer = Color(0xFF316BF3);
  static const onSecondary = Color(0xFFFFFFFF);
  static const onSecondaryContainer = Color(0xFFFEFCFF);

  static const background = Color(0xFFFCF8FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceGray = Color(0xFFF8FAFC);
  static const surfaceContainerLow = Color(0xFFF6F3F5);
  static const surfaceContainer = Color(0xFFF0EDEF);
  static const surfaceContainerHigh = Color(0xFFEAE7E9);
  static const surfaceContainerHighest = Color(0xFFE4E2E4);
  static const surfaceDim = Color(0xFFDCD9DB);
  static const inverseSurface = Color(0xFF303032);
  static const inverseOnSurface = Color(0xFFF3F0F2);

  static const textCharcoal = Color(0xFF1E293B);
  static const textMuted = Color(0xFF64748B);
  static const onSurface = Color(0xFF1B1B1D);
  static const onSurfaceVariant = Color(0xFF45464D);
  static const onPrimary = Color(0xFFFFFFFF);

  static const borderSubtle = Color(0xFFE2E8F0);
  static const outline = Color(0xFF76777D);
  static const outlineVariant = Color(0xFFC6C6CD);

  static const available = Color(0xFF10B981);
  static const availableSurface = Color(0x1A10B981);
  static const booked = Color(0xFFEF4444);
  static const bookedSurface = Color(0x1AEF4444);
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onError = Color(0xFFFFFFFF);
  static const onErrorContainer = Color(0xFF93000A);
  static const pending = Color(0xFFF59E0B);
  static const pendingSurface = Color(0x1AF59E0B);
  
  static const ambientShadow = Color(0x0D0F172A);

  static const shimmerBase = Color(0xFFE4E2E4);
  static const shimmerHighlight = Color(0xFFF6F3F5);
}

abstract class AppRadius {
  static const xs = 2.0;
  static const sm = 4.0;
  static const md = 6.0;
  static const lg = 8.0;
  static const xl = 12.0;
  static const full = 9999.0;
}

abstract class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

const kAmbientShadow = BoxShadow(
  color: AppColors.ambientShadow,
  blurRadius: 20,
  offset: Offset(0, 4),
);

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
      ),
      textTheme: _buildTextTheme(),
      inputDecorationTheme: _buildInputDecoration(),
      elevatedButtonTheme: _buildElevatedButton(),
      outlinedButtonTheme: _buildOutlinedButton(),
      textButtonTheme: _buildTextButton(),
      cardTheme: _buildCardTheme(),
      appBarTheme: _buildAppBarTheme(),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        space: 1,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.inverseSurface,
        contentTextStyle: GoogleFonts.inter(
          color: AppColors.inverseOnSurface,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.all(AppSpacing.md),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceGray,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textCharcoal,
        ),
        side: const BorderSide(color: AppColors.borderSubtle),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 48,
        color: AppColors.textCharcoal,
        height: 56 / 48
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 32, fontWeight: FontWeight.w600,
        color: AppColors.textCharcoal,
        height: 40 / 32, letterSpacing: -0.01 * 32,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 24, fontWeight: FontWeight.w600,
        color: AppColors.textCharcoal,
        height: 32 / 24,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 20, fontWeight: FontWeight.w600,
        color: AppColors.textCharcoal,
        height: 28 / 20,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: AppColors.textCharcoal,
        height: 1.4,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600,
        color: AppColors.textCharcoal,
        height: 1.4,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w500,
        color: AppColors.textCharcoal, height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w500,
        color: AppColors.textCharcoal, height: 1.4,
        letterSpacing: 0.01 * 14,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w500,
        color: AppColors.textMuted, height: 1.4,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400,
        color: AppColors.textCharcoal,
        height: 24 / 16, letterSpacing: 0.01 * 16,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        height: 20 / 14,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400,
        color: AppColors.textMuted, height: 1.5,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w500,
        color: AppColors.textCharcoal,
        height: 16 / 12, letterSpacing: 0.05 * 12,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
        height: 14 / 11, letterSpacing: 0.03 * 11,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10, fontWeight: FontWeight.w500,
        color: AppColors.textMuted, letterSpacing: 0.04 * 10,
        height: 1.4,
      ),
    );
  }

  static InputDecorationTheme _buildInputDecoration() {
    const enabledBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
      borderSide: BorderSide(color: AppColors.borderSubtle, width: 1),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 14,
      ),
      border: enabledBorder,
      enabledBorder: enabledBorder,
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
        borderSide: BorderSide(color: AppColors.secondary, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
        borderSide: BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14, color: AppColors.outline,
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14, color: AppColors.onSurfaceVariant,
      ),
      floatingLabelStyle: GoogleFonts.inter(
        fontSize: 12, color: AppColors.secondary,
      ),
      errorStyle: GoogleFonts.inter(
        fontSize: 12, color: AppColors.error,
      ),
      prefixIconColor: AppColors.onSurfaceVariant,
      suffixIconColor: AppColors.onSurfaceVariant,
    );
  }

  static ElevatedButtonThemeData _buildElevatedButton() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size.fromHeight(48),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
        textStyle: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.2,
        ),
      ).copyWith(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return AppColors.primaryContainer;
          if (states.contains(WidgetState.disabled)) return AppColors.surfaceContainerHighest;
          return AppColors.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return AppColors.outline;
          return AppColors.onPrimary;
        }),
        elevation: WidgetStateProperty.all(0),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButton() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surfaceGray,
        foregroundColor: AppColors.textCharcoal,
        minimumSize: const Size.fromHeight(48),
        side: const BorderSide(color: AppColors.borderSubtle),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
        ),
        elevation: 0,
        textStyle: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButton() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.secondary,
        textStyle: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w500,
        ),
        minimumSize: const Size(44, 44), // min tap target
      ),
    );
  }

  static CardThemeData _buildCardTheme() {
    return const CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        side: BorderSide(color: AppColors.borderSubtle, width: 1),
      ),
      margin: EdgeInsets.zero,
    );
  }

  static AppBarTheme _buildAppBarTheme() {
    return AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textCharcoal,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.ambientShadow,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600,
        color: AppColors.textCharcoal,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.textCharcoal,
        size: 22,
      ),
    );
  }
}