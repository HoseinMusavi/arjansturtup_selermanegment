import 'package:flutter/material.dart';

/// Brand and semantic color tokens.
///
/// These raw tokens are the only place where brand colors are hard-coded.
/// [AppTheme] derives a complete Material 3 [ColorScheme] from [brandPrimary],
/// and widgets reference theme roles (`Theme.of(context).colorScheme`) rather
/// than these constants, so dark mode stays correct automatically.
class AppColors {
  AppColors._();

  // --- Brand ------------------------------------------------------------

  /// Primary brand color — teal, conveying freshness and professionalism,
  /// intentionally distinct from the legacy panel's generic palette.
  static const Color brandPrimary = Color(0xFF0D9488);

  /// Darker brand shade used for pressed states and gradients.
  static const Color brandPrimaryDark = Color(0xFF0F766E);

  /// Light brand tint used for subtle highlights and onboarding art.
  static const Color brandPrimaryLight = Color(0xFF99F6E4);

  /// Accent color — warm amber for calls to action and highlights.
  static const Color accent = Color(0xFFF59E0B);

  // --- Semantic ---------------------------------------------------------

  /// Success — published items, completed orders, positive balances.
  static const Color success = Color(0xFF16A34A);

  /// Container tint for success chips and banners.
  static const Color successContainer = Color(0xFFDCFCE7);

  /// Warning — pending moderation, limited stock, attention needed.
  static const Color warning = Color(0xFFD97706);

  static const Color warningContainer = Color(0xFFFEF3C7);

  /// Error — failures, destructive actions, rejected records.
  static const Color error = Color(0xFFDC2626);

  static const Color errorContainer = Color(0xFFFEE2E2);

  /// Information — neutral notifications and help surfaces.
  static const Color info = Color(0xFF2563EB);

  static const Color infoContainer = Color(0xFFDBEAFE);

  // --- Neutrals ---------------------------------------------------------

  static const Color neutral900 = Color(0xFF111827);
  static const Color neutral800 = Color(0xFF1F2937);
  static const Color neutral700 = Color(0xFF374151);
  static const Color neutral600 = Color(0xFF4B5563);
  static const Color neutral500 = Color(0xFF6B7280);
  static const Color neutral400 = Color(0xFF9CA3AF);
  static const Color neutral300 = Color(0xFFD1D5DB);
  static const Color neutral200 = Color(0xFFE5E7EB);
  static const Color neutral100 = Color(0xFFF3F4F6);
  static const Color neutral50 = Color(0xFFF9FAFB);

  // --- Functional -------------------------------------------------------

  /// Overlay scrim used behind dialogs and bottom sheets.
  static const Color scrim = Color(0x66000000);

  /// Subtle divider color on light surfaces.
  static const Color divider = neutral200;

  /// Foreground for disabled controls.
  static const Color disabled = neutral400;
}

/// Maps semantic domain concepts to concrete color pairs.
///
/// Status is never expressed with color alone (accessibility requirement):
/// every consumer pairs these colors with a Persian label or icon.
class AppSemanticColors {
  const AppSemanticColors();

  Color get success => AppColors.success;
  Color get successContainer => AppColors.successContainer;
  Color get warning => AppColors.warning;
  Color get warningContainer => AppColors.warningContainer;
  Color get error => AppColors.error;
  Color get errorContainer => AppColors.errorContainer;
  Color get info => AppColors.info;
  Color get infoContainer => AppColors.infoContainer;
}
