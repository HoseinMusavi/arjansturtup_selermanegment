import 'package:flutter/widgets.dart';

/// Centralized corner radius scale.
///
/// Keeping radii in one place guarantees cards, buttons, inputs and sheets
/// always share a coherent visual language.
class AppRadius {
  AppRadius._();

  /// 0 dp — dividers and full-bleed imagery.
  static const double none = 0;

  /// 8 dp — small chips and badges.
  static const double sm = 8;

  /// 12 dp — buttons and text fields.
  static const double md = 12;

  /// 16 dp — cards and list containers.
  static const double lg = 16;

  /// 20 dp — prominent surfaces such as bottom sheets.
  static const double xl = 20;

  /// 28 dp — large dialogs and feature cards.
  static const double xl2 = 28;

  /// Fully rounded — pills, status dots, circular avatars.
  static const double pill = 999;

  static const Radius radiusSm = Radius.circular(sm);
  static const Radius radiusMd = Radius.circular(md);
  static const Radius radiusLg = Radius.circular(lg);
  static const Radius radiusXl = Radius.circular(xl);
  static const Radius radiusXl2 = Radius.circular(xl2);

  /// Default card border radius.
  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));

  /// Radius of small surfaces (chips, badges, tags).
  static const BorderRadius small = BorderRadius.all(Radius.circular(sm));

  /// Radius of interactive controls (buttons, inputs).
  static const BorderRadius control = BorderRadius.all(Radius.circular(md));

  /// Radius used for the top corners of bottom sheets.
  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(xl2),
  );
}
