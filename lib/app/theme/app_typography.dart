import 'package:flutter/material.dart';

/// The single font family bundled with the application.
///
/// Vazirmatn is a modern, open-source Persian typeface that renders Persian
/// text, Persian digits and Latin text cleanly, and supports the full weight
/// range needed by the type scale.
class AppFontFamily {
  AppFontFamily._();

  static const String primary = 'Vazirmatn';
}

/// Application type scale.
///
/// Sizes are deliberately tuned for Persian text, which typically needs a
/// slightly larger base than Latin-only designs to stay legible at small
/// sizes. Widgets reference [AppTextStyle] or the Material [TextTheme]; raw
/// font sizes are avoided throughout the UI.
class AppTypography {
  AppTypography._();

  // --- Font sizes -------------------------------------------------------

  static const double displaySmallSize = 32;
  static const double headlineLargeSize = 28;
  static const double headlineMediumSize = 24;
  static const double headlineSmallSize = 20;
  static const double titleLargeSize = 18;
  static const double titleMediumSize = 16;
  static const double titleSmallSize = 14;
  static const double bodyLargeSize = 15;
  static const double bodyMediumSize = 14;
  static const double bodySmallSize = 13;
  static const double labelLargeSize = 14;
  static const double labelMediumSize = 12;
  static const double labelSmallSize = 11;

  // --- Line heights -----------------------------------------------------

  static const double tightLineHeight = 1.2;
  static const double normalLineHeight = 1.45;
  static const double relaxedLineHeight = 1.6;

  /// Builds the base [TextTheme] using the bundled Persian font family.
  ///
  /// [ColorScheme] supplies on-surface colors later via [applyDefaults], so
  /// this method only fixes family, size and weight.
  static TextTheme baseTextTheme() {
    const family = AppFontFamily.primary;

    return TextTheme(
      displaySmall: TextStyle(
        fontFamily: family,
        fontSize: displaySmallSize,
        fontWeight: FontWeight.w700,
        height: tightLineHeight,
      ),
      headlineLarge: TextStyle(
        fontFamily: family,
        fontSize: headlineLargeSize,
        fontWeight: FontWeight.w700,
        height: tightLineHeight,
      ),
      headlineMedium: TextStyle(
        fontFamily: family,
        fontSize: headlineMediumSize,
        fontWeight: FontWeight.w700,
        height: tightLineHeight,
      ),
      headlineSmall: TextStyle(
        fontFamily: family,
        fontSize: headlineSmallSize,
        fontWeight: FontWeight.w600,
        height: tightLineHeight,
      ),
      titleLarge: TextStyle(
        fontFamily: family,
        fontSize: titleLargeSize,
        fontWeight: FontWeight.w700,
        height: tightLineHeight,
      ),
      titleMedium: TextStyle(
        fontFamily: family,
        fontSize: titleMediumSize,
        fontWeight: FontWeight.w600,
        height: normalLineHeight,
      ),
      titleSmall: TextStyle(
        fontFamily: family,
        fontSize: titleSmallSize,
        fontWeight: FontWeight.w600,
        height: normalLineHeight,
      ),
      bodyLarge: TextStyle(
        fontFamily: family,
        fontSize: bodyLargeSize,
        fontWeight: FontWeight.w400,
        height: normalLineHeight,
      ),
      bodyMedium: TextStyle(
        fontFamily: family,
        fontSize: bodyMediumSize,
        fontWeight: FontWeight.w400,
        height: normalLineHeight,
      ),
      bodySmall: TextStyle(
        fontFamily: family,
        fontSize: bodySmallSize,
        fontWeight: FontWeight.w400,
        height: relaxedLineHeight,
      ),
      labelLarge: TextStyle(
        fontFamily: family,
        fontSize: labelLargeSize,
        fontWeight: FontWeight.w600,
        height: normalLineHeight,
      ),
      labelMedium: TextStyle(
        fontFamily: family,
        fontSize: labelMediumSize,
        fontWeight: FontWeight.w500,
        height: normalLineHeight,
      ),
      labelSmall: TextStyle(
        fontFamily: family,
        fontSize: labelSmallSize,
        fontWeight: FontWeight.w500,
        height: normalLineHeight,
      ),
    );
  }
}

/// Reusable, opinionated text styles that are not part of the Material scale.
class AppTextStyle {
  AppTextStyle._();

  /// Large monetary value shown on dashboard cards.
  static const TextStyle moneyDisplay = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppTypography.headlineLargeSize,
    fontWeight: FontWeight.w700,
    height: AppTypography.tightLineHeight,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Numeric value paired with [moneyDisplay].
  static const TextStyle moneyBody = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppTypography.titleMediumSize,
    fontWeight: FontWeight.w600,
    height: AppTypography.tightLineHeight,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Caption used above dashboard metrics.
  static const TextStyle metricCaption = TextStyle(
    fontFamily: AppFontFamily.primary,
    fontSize: AppTypography.labelMediumSize,
    fontWeight: FontWeight.w500,
    height: AppTypography.normalLineHeight,
  );
}
