import 'package:flutter/widgets.dart';

/// A single source of truth for vertical and horizontal rhythm.
///
/// Every widget reads from [AppSpacing] instead of typing literal pixel values,
/// which keeps padding consistent and makes global tuning a one-line change.
class AppSpacing {
  AppSpacing._();

  /// Hairline gap (4 dp) — tight groupings inside a single component.
  static const double xs2 = 4;

  /// Small gap (8 dp) — related elements such as an icon and its label.
  static const double xs = 8;

  /// Medium gap (12 dp) — default gap between sibling widgets inside a card.
  static const double sm = 12;

  /// Standard gap (16 dp) — default content padding of a screen or card.
  static const double md = 16;

  /// Large gap (20 dp) — separation between sections.
  static const double lg = 20;

  /// Extra large gap (24 dp) — major section separation.
  static const double xl = 24;

  /// 32 dp — spacing around prominent, full-width actions.
  static const double xl2 = 32;

  /// 40 dp — vertical breathing room on empty states.
  static const double xl3 = 40;

  /// 48 dp — vertical padding of centered error states.
  static const double xl4 = 48;

  /// 64 dp — generous page-level whitespace.
  static const double xl5 = 64;

  // --- Edge insets -------------------------------------------------------

  /// Padding for a screen's root scrollable content.
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(
    horizontal: md,
  );

  /// Padding wrapping a whole card.
  static const EdgeInsets cardPadding = EdgeInsets.all(md);

  /// Compact padding for dense list rows.
  static const EdgeInsets rowCompact = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  /// Padding used inside bottom sheets and dialogs.
  static const EdgeInsets sheetPadding = EdgeInsets.fromLTRB(md, md, md, xl);

  /// Gap applied between the sections of a form.
  static const SizedBox formSectionGap = SizedBox(height: xl);

  /// Gap applied between fields in the same form section.
  static const SizedBox formFieldGap = SizedBox(height: md);

  /// Default gap between buttons in an action row.
  static const SizedBox actionGap = SizedBox(width: sm);
}
