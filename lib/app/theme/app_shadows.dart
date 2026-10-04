import 'package:flutter/material.dart';

/// Elevation and shadow tokens.
///
/// Material 3 expresses depth through tonal elevation rather than heavy
/// shadows, so most surfaces simply use [ElevationToken]s. A small set of
/// explicit shadows is provided for surfaces that sit above the standard
/// hierarchy (sticky headers, floating action areas).
class ElevationToken {
  ElevationToken._();

  /// Flat surface — background canvas.
  static const double none = 0;

  /// Subtle lift — list rows, dividers replaced by tonal fill.
  static const double level1 = 1;

  /// Cards and standard containers.
  static const double level2 = 2;

  /// Raised interactive surfaces, app bars when scrolled.
  static const double level3 = 3;

  /// Dialogs and popovers.
  static const double level4 = 4;

  /// Sheets that slide over content.
  static const double level5 = 6;
}

class AppShadows {
  AppShadows._();

  /// Soft shadow for primary cards.
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 2)),
  ];

  /// Slightly stronger shadow for sticky/floating elements.
  static const List<BoxShadow> raised = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 16, offset: Offset(0, 4)),
  ];

  /// Shadow for bottom sheets and dialogs.
  static const List<BoxShadow> sheet = [
    BoxShadow(color: Color(0x33000000), blurRadius: 24, offset: Offset(0, -6)),
  ];
}
