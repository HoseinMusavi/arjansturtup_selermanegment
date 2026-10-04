import 'package:flutter/material.dart';

/// Centralized route path constants.
///
/// Widgets and deep-links reference [AppRoutes] instead of literal strings so
/// renames are safe and navigation stays greppable.
class AppRoutes {
  AppRoutes._();

  /// Authentication flow.
  static const String login = '/login';

  /// Root of the authenticated experience (the adaptive shell).
  static const String home = '/';

  // --- Shell branches ----------------------------------------------------

  static const String dashboard = 'dashboard';
  static const String orders = 'orders';
  static const String catalog = 'catalog';
  static const String products = 'catalog/products';
  static const String productEditor = 'catalog/products/editor';
  static const String categories = 'catalog/categories';
  static const String sizes = 'catalog/sizes';
  static const String addons = 'catalog/addons';
  static const String finance = 'finance';
  static const String invoices = 'finance/invoices';
  static const String vouchers = 'finance/vouchers';
  static const String reviews = 'reviews';
  static const String team = 'team';
  static const String settings = 'settings';

  /// Grouped "More" destination collecting secondary sections.
  static const String more = 'more';

  /// Fully qualified branch paths used by [GoRouter] top-level routes.
  static const String dashboardPath = '/dashboard';
  static const String ordersPath = '/orders';
  static const String catalogPath = '/catalog';
  static const String financePath = '/finance';
  static const String morePath = '/more';
  static const String reviewsPath = '/reviews';
  static const String teamPath = '/team';
  static const String settingsPath = '/settings';

  /// Primary navigation branches rendered by the adaptive shell.
  ///
  /// Kept to five destinations so the compact bottom navigation bar stays
  /// within Material 3 guidance. Secondary sections live under [morePath].
  static const List<String> primaryDestinations = [
    dashboardPath,
    ordersPath,
    catalogPath,
    financePath,
    morePath,
  ];

  /// Secondary sections reachable from the "More" screen.
  static const List<String> secondaryDestinations = [
    reviewsPath,
    teamPath,
    settingsPath,
  ];
}

/// Metadata describing a top-level navigation destination.
///
/// The adaptive shell renders the same destinations as a bottom bar, a rail
/// or a sidebar depending on the viewport class, so the destination list is
/// defined exactly once here.
class NavDestination {
  const NavDestination({
    required this.path,
    required this.labelKey,
    required this.icon,
    required this.selectedIcon,
  });

  /// Route path this destination navigates to.
  final String path;

  /// Localization key used for the visible label.
  final String labelKey;

  /// Outlined icon shown when the destination is inactive.
  final IconData icon;

  /// Filled icon shown when the destination is selected.
  final IconData selectedIcon;
}
