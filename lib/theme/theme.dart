import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// BABYMAMA DESIGN SYSTEM
// ─────────────────────────────────────────────
// Stack: Flutter Material 3
// Fonts: Cormorant Garamond (display) · DM Sans (body)
// Add to pubspec.yaml:
//   google_fonts: ^6.2.1
// Then replace fontFamily strings with:
//   GoogleFonts.cormorantGaramond(...) / GoogleFonts.dmSans(...)
// ─────────────────────────────────────────────

// ── 1. COLORS ────────────────────────────────

class BabyMamaColors {
  BabyMamaColors._();

  // Brand
  static const Color primary        = Color(0xFFC4847A); // muted terracotta rose
  static const Color primaryLight   = Color(0xFFDDAFA9); // blush
  static const Color primaryDark    = Color(0xFF9C5F56); // deep rose

  static const Color secondary      = Color(0xFF9BAF9B); // muted sage green
  static const Color secondaryLight = Color(0xFFBECEBE);
  static const Color secondaryDark  = Color(0xFF728F72);

  static const Color accent         = Color(0xFFD4B896); // warm champagne gold

  // Backgrounds
  static const Color background     = Color(0xFFFDF8F5); // warm cream
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5EDE8); // linen

  // Content
  static const Color onPrimary      = Color(0xFFFFFFFF);
  static const Color onSecondary    = Color(0xFFFFFFFF);
  static const Color onBackground   = Color(0xFF2D2420); // warm charcoal
  static const Color onSurface      = Color(0xFF2D2420);

  // Neutrals (warm-tinted grays)
  static const Color neutral900     = Color(0xFF2D2420);
  static const Color neutral700     = Color(0xFF6B5E58);
  static const Color neutral500     = Color(0xFF9E8E87);
  static const Color neutral300     = Color(0xFFCFC4BF);
  static const Color neutral100     = Color(0xFFF0EAE7);
  static const Color neutral50      = Color(0xFFFAF6F4);

  // Semantic
  static const Color error          = Color(0xFFB5534A);
  static const Color errorLight     = Color(0xFFF9E5E4);
  static const Color success        = Color(0xFF6A9B7E);
  static const Color successLight   = Color(0xFFE4F0E9);
  static const Color warning        = Color(0xFFCB9A52);
  static const Color warningLight   = Color(0xFFFAF0E0);

  // Overlay
  static const Color scrim          = Color(0x662D2420);
  static const Color divider        = Color(0xFFEAE0DC);
}

// ── 2. TYPOGRAPHY ─────────────────────────────

class BabyMamaTypography {
  BabyMamaTypography._();

  // Font families
  static const String _display = 'Cormorant Garamond'; // serif — emotion & elegance
  static const String _body    = 'DM Sans';            // sans-serif — clarity & warmth

  // Display — hero titles, splash screens
  static const TextStyle displayLarge = TextStyle(
    fontFamily: _display,
    fontSize: 48,
    fontWeight: FontWeight.w300,
    height: 1.15,
    letterSpacing: -0.5,
    color: BabyMamaColors.neutral900,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _display,
    fontSize: 38,
    fontWeight: FontWeight.w300,
    height: 1.2,
    letterSpacing: -0.25,
    color: BabyMamaColors.neutral900,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: _display,
    fontSize: 30,
    fontWeight: FontWeight.w400,
    height: 1.25,
    color: BabyMamaColors.neutral900,
  );

  // Headlines — section titles, card headers
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: _display,
    fontSize: 26,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: BabyMamaColors.neutral900,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: _display,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: BabyMamaColors.neutral900,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: _display,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: BabyMamaColors.neutral900,
  );

  // Titles — list items, dialogs, navigation
  static const TextStyle titleLarge = TextStyle(
    fontFamily: _body,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.1,
    color: BabyMamaColors.neutral900,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _body,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 0.1,
    color: BabyMamaColors.neutral900,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: _body,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.45,
    letterSpacing: 0.1,
    color: BabyMamaColors.neutral700,
  );

  // Body — paragraphs, descriptions
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _body,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: BabyMamaColors.neutral700,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _body,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: BabyMamaColors.neutral700,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _body,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.55,
    color: BabyMamaColors.neutral500,
  );

  // Labels — buttons, tags, captions
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _body,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0.4,
    color: BabyMamaColors.neutral900,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _body,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0.4,
    color: BabyMamaColors.neutral700,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: _body,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0.6,
    color: BabyMamaColors.neutral500,
  );
}

// ── 3. SPACING ────────────────────────────────

class BabyMamaSpacing {
  BabyMamaSpacing._();

  // Base unit: 4px
  static const double xs2  = 2.0;
  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 20.0;
  static const double xl2  = 24.0;
  static const double xl3  = 32.0;
  static const double xl4  = 40.0;
  static const double xl5  = 48.0;
  static const double xl6  = 64.0;

  // Semantic aliases
  static const double screenPadding     = lg;
  static const double cardPadding       = xl2;
  static const double sectionGap        = xl3;
  static const double itemGap           = lg;
  static const double inputVertical     = md;
  static const double inputHorizontal   = lg;
}

// ── 4. BORDER RADIUS ──────────────────────────

class BabyMamaRadius {
  BabyMamaRadius._();

  static const double none   = 0.0;
  static const double xs     = 4.0;
  static const double sm     = 8.0;
  static const double md     = 12.0;
  static const double lg     = 16.0;
  static const double xl     = 24.0;
  static const double full   = 999.0;

  // BorderRadius shorthands
  static final BorderRadius noneAll  = BorderRadius.circular(none);
  static final BorderRadius xsAll    = BorderRadius.circular(xs);
  static final BorderRadius smAll    = BorderRadius.circular(sm);
  static final BorderRadius mdAll    = BorderRadius.circular(md);
  static final BorderRadius lgAll    = BorderRadius.circular(lg);
  static final BorderRadius xlAll    = BorderRadius.circular(xl);
  static final BorderRadius fullAll  = BorderRadius.circular(full);

  // Semantic aliases
  static final BorderRadius card     = mdAll;   // 12
  static final BorderRadius button   = fullAll; // pill shape
  static final BorderRadius input    = smAll;   // 8
  static final BorderRadius modal    = lgAll;   // 16
  static final BorderRadius chip     = fullAll;
  static final BorderRadius avatar   = fullAll;
}

// ── 5. SHADOWS ────────────────────────────────

class BabyMamaShadows {
  BabyMamaShadows._();

  // Warm-tinted shadows (avoid cold gray)
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> xs = [
    BoxShadow(
      color: Color(0x0A2D2420),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0F2D2420),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x052D2420),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x142D2420),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0A2D2420),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1A2D2420),
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0A2D2420),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x202D2420),
      blurRadius: 48,
      offset: Offset(0, 16),
    ),
    BoxShadow(
      color: Color(0x0A2D2420),
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  // Semantic aliases
  static const List<BoxShadow> card    = sm;
  static const List<BoxShadow> modal   = lg;
  static const List<BoxShadow> button  = xs;
  static const List<BoxShadow> fab     = md;
}

// ── 6. BUTTON STYLES ──────────────────────────

class BabyMamaButtonStyles {
  BabyMamaButtonStyles._();

  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: BabyMamaColors.primary,
    foregroundColor: BabyMamaColors.onPrimary,
    disabledBackgroundColor: BabyMamaColors.neutral300,
    disabledForegroundColor: BabyMamaColors.neutral500,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BabyMamaRadius.button),
    padding: const EdgeInsets.symmetric(
      horizontal: BabyMamaSpacing.xl3,
      vertical: BabyMamaSpacing.md,
    ),
    minimumSize: const Size(0, 52),
    textStyle: BabyMamaTypography.labelLarge.copyWith(
      color: BabyMamaColors.onPrimary,
    ),
  );

  static ButtonStyle secondary = OutlinedButton.styleFrom(
    foregroundColor: BabyMamaColors.primary,
    disabledForegroundColor: BabyMamaColors.neutral300,
    side: const BorderSide(color: BabyMamaColors.primary, width: 1.5),
    shape: RoundedRectangleBorder(borderRadius: BabyMamaRadius.button),
    padding: const EdgeInsets.symmetric(
      horizontal: BabyMamaSpacing.xl3,
      vertical: BabyMamaSpacing.md,
    ),
    minimumSize: const Size(0, 52),
    textStyle: BabyMamaTypography.labelLarge.copyWith(
      color: BabyMamaColors.primary,
    ),
  );

  static ButtonStyle ghost = TextButton.styleFrom(
    foregroundColor: BabyMamaColors.primary,
    disabledForegroundColor: BabyMamaColors.neutral300,
    shape: RoundedRectangleBorder(borderRadius: BabyMamaRadius.button),
    padding: const EdgeInsets.symmetric(
      horizontal: BabyMamaSpacing.lg,
      vertical: BabyMamaSpacing.md,
    ),
    minimumSize: const Size(0, 48),
    textStyle: BabyMamaTypography.labelLarge.copyWith(
      color: BabyMamaColors.primary,
    ),
  );

  static ButtonStyle destructive = ElevatedButton.styleFrom(
    backgroundColor: BabyMamaColors.error,
    foregroundColor: BabyMamaColors.onPrimary,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BabyMamaRadius.button),
    padding: const EdgeInsets.symmetric(
      horizontal: BabyMamaSpacing.xl3,
      vertical: BabyMamaSpacing.md,
    ),
    minimumSize: const Size(0, 52),
  );
}

// ── 7. INPUT DECORATION THEME ─────────────────

class BabyMamaInputStyles {
  BabyMamaInputStyles._();

  static InputDecorationTheme decorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: BabyMamaColors.neutral50,

    contentPadding: const EdgeInsets.symmetric(
      horizontal: BabyMamaSpacing.inputHorizontal,
      vertical: BabyMamaSpacing.inputVertical + 2,
    ),

    // Borders
    border: OutlineInputBorder(
      borderRadius: BabyMamaRadius.input,
      borderSide: const BorderSide(color: BabyMamaColors.neutral300, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BabyMamaRadius.input,
      borderSide: const BorderSide(color: BabyMamaColors.neutral300, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BabyMamaRadius.input,
      borderSide: const BorderSide(color: BabyMamaColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BabyMamaRadius.input,
      borderSide: const BorderSide(color: BabyMamaColors.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BabyMamaRadius.input,
      borderSide: const BorderSide(color: BabyMamaColors.error, width: 1.5),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BabyMamaRadius.input,
      borderSide: const BorderSide(color: BabyMamaColors.neutral100, width: 1),
    ),

    // Labels & hints
    labelStyle: BabyMamaTypography.bodyMedium.copyWith(
      color: BabyMamaColors.neutral500,
    ),
    hintStyle: BabyMamaTypography.bodyMedium.copyWith(
      color: BabyMamaColors.neutral300,
    ),
    errorStyle: BabyMamaTypography.bodySmall.copyWith(
      color: BabyMamaColors.error,
    ),
    floatingLabelStyle: BabyMamaTypography.labelSmall.copyWith(
      color: BabyMamaColors.primary,
    ),
  );
}

// ── 8. THEME ──────────────────────────────────

class BabyMamaTheme {
  BabyMamaTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,

      primary: BabyMamaColors.primary,
      onPrimary: BabyMamaColors.onPrimary,
      primaryContainer: BabyMamaColors.primaryLight,
      onPrimaryContainer: BabyMamaColors.primaryDark,

      secondary: BabyMamaColors.secondary,
      onSecondary: BabyMamaColors.onSecondary,
      secondaryContainer: BabyMamaColors.secondaryLight,
      onSecondaryContainer: BabyMamaColors.secondaryDark,

      tertiary: BabyMamaColors.accent,
      onTertiary: BabyMamaColors.onPrimary,
      tertiaryContainer: const Color(0xFFF2E4D4),
      onTertiaryContainer: BabyMamaColors.neutral700,

      error: BabyMamaColors.error,
      onError: BabyMamaColors.onPrimary,
      errorContainer: BabyMamaColors.errorLight,
      onErrorContainer: BabyMamaColors.error,

      surface: BabyMamaColors.surface,
      onSurface: BabyMamaColors.onSurface,
      surfaceContainerHighest: BabyMamaColors.surfaceVariant,
      onSurfaceVariant: BabyMamaColors.neutral700,

      outline: BabyMamaColors.neutral300,
      outlineVariant: BabyMamaColors.neutral100,
      shadow: BabyMamaColors.neutral900,
      scrim: BabyMamaColors.scrim,
      inverseSurface: BabyMamaColors.neutral900,
      onInverseSurface: BabyMamaColors.neutral50,
      inversePrimary: BabyMamaColors.primaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: BabyMamaColors.background,
      dividerColor: BabyMamaColors.divider,

      // Typography
      textTheme: const TextTheme(
        displayLarge:  BabyMamaTypography.displayLarge,
        displayMedium: BabyMamaTypography.displayMedium,
        displaySmall:  BabyMamaTypography.displaySmall,

        headlineLarge:  BabyMamaTypography.headlineLarge,
        headlineMedium: BabyMamaTypography.headlineMedium,
        headlineSmall:  BabyMamaTypography.headlineSmall,

        titleLarge:  BabyMamaTypography.titleLarge,
        titleMedium: BabyMamaTypography.titleMedium,
        titleSmall:  BabyMamaTypography.titleSmall,

        bodyLarge:  BabyMamaTypography.bodyLarge,
        bodyMedium: BabyMamaTypography.bodyMedium,
        bodySmall:  BabyMamaTypography.bodySmall,

        labelLarge:  BabyMamaTypography.labelLarge,
        labelMedium: BabyMamaTypography.labelMedium,
        labelSmall:  BabyMamaTypography.labelSmall,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: BabyMamaButtonStyles.primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: BabyMamaButtonStyles.secondary,
      ),
      textButtonTheme: TextButtonThemeData(
        style: BabyMamaButtonStyles.ghost,
      ),

      // Input
      inputDecorationTheme: BabyMamaInputStyles.decorationTheme,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: BabyMamaColors.background,
        foregroundColor: BabyMamaColors.neutral900,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: BabyMamaTypography.titleLarge,
        iconTheme: const IconThemeData(
          color: BabyMamaColors.neutral900,
          size: 24,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: BabyMamaColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BabyMamaRadius.card),
        margin: EdgeInsets.zero,
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: BabyMamaColors.surface,
        selectedItemColor: BabyMamaColors.primary,
        unselectedItemColor: BabyMamaColors.neutral500,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: BabyMamaTypography.labelSmall,
        unselectedLabelStyle: BabyMamaTypography.labelSmall,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: BabyMamaColors.neutral100,
        selectedColor: BabyMamaColors.primaryLight,
        labelStyle: BabyMamaTypography.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: BabyMamaSpacing.md,
          vertical: BabyMamaSpacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: BabyMamaRadius.chip),
        side: BorderSide.none,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: BabyMamaColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: BabyMamaColors.neutral900,
        contentTextStyle: BabyMamaTypography.bodyMedium.copyWith(
          color: BabyMamaColors.neutral50,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BabyMamaRadius.smAll),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: BabyMamaColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BabyMamaRadius.modal),
        titleTextStyle: BabyMamaTypography.headlineSmall,
        contentTextStyle: BabyMamaTypography.bodyMedium,
      ),

      // BottomSheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: BabyMamaColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(BabyMamaRadius.lg),
          ),
        ),
      ),

      // Switch / Checkbox / Radio
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BabyMamaColors.onPrimary;
          }
          return BabyMamaColors.neutral500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BabyMamaColors.primary;
          }
          return BabyMamaColors.neutral300;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BabyMamaColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(BabyMamaColors.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BabyMamaRadius.xsAll),
        side: const BorderSide(color: BabyMamaColors.neutral300, width: 1.5),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return BabyMamaColors.primary;
          }
          return BabyMamaColors.neutral300;
        }),
      ),
    );
  }
}
