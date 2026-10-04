/// Semantic viewport breakpoints shared by the whole application.
///
/// Instead of scattering raw pixel comparisons across widgets, layouts ask for
/// a [WindowSizeClass] and branch on that. This keeps adaptive logic in one
/// place and makes every responsive decision unit-testable.
///
/// The classes follow Material 3 window-size guidance:
/// * [compact]   — phones in portrait (< 600 dp)
/// * [medium]    — small tablets / phones in landscape (600–839 dp)
/// * [expanded]  — tablets in portrait and larger (>= 840 dp)
library;

/// The three semantic size classes used throughout the app.
enum WindowSizeClass {
  compact,
  medium,
  expanded;

  /// Upper width bound (exclusive) for each class, in logical pixels.
  static const double compactBreakpoint = 600;
  static const double mediumBreakpoint = 840;

  /// Resolves the class for the given [width] in logical pixels.
  static WindowSizeClass of(double width) {
    if (width < compactBreakpoint) return WindowSizeClass.compact;
    if (width < mediumBreakpoint) return WindowSizeClass.medium;
    return WindowSizeClass.expanded;
  }

  /// Whether the viewport is phone-like: bottom navigation is appropriate.
  bool get isCompact => this == WindowSizeClass.compact;

  /// Whether the viewport is small-tablet-like: navigation rail is appropriate.
  bool get isMedium => this == WindowSizeClass.medium;

  /// Whether the viewport is large: a persistent navigation panel fits.
  bool get isExpanded => this == WindowSizeClass.expanded;

  /// Handheld form factor — use bottom navigation or a drawer.
  bool get isHandheld => isCompact || isMedium;

  /// Tablet-or-larger form factor — a permanent navigation panel fits.
  bool get isWide => isExpanded;

  /// Number of columns a grid should use for list-style content.
  int get gridCrossAxisCount {
    switch (this) {
      case WindowSizeClass.compact:
        return 1;
      case WindowSizeClass.medium:
        return 2;
      case WindowSizeClass.expanded:
        return 3;
    }
  }

  /// Recommended navigation paradigm for the current class.
  NavigationParadigm get navigationParadigm {
    switch (this) {
      case WindowSizeClass.compact:
        return NavigationParadigm.bottomBar;
      case WindowSizeClass.medium:
        return NavigationParadigm.rail;
      case WindowSizeClass.expanded:
        return NavigationParadigm.sidebar;
    }
  }
}

/// The navigation chrome recommended for a given viewport class.
///
/// The underlying navigation *logic* is shared; only the chrome changes.
enum NavigationParadigm {
  /// Bottom navigation bar (compact phones).
  bottomBar,

  /// Compact vertical rail (small tablets, landscape phones).
  rail,

  /// Persistent side panel (large tablets, desktop, web).
  sidebar,
}
