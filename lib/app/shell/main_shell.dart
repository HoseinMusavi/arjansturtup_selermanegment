import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/responsive_builder.dart';
import '../l10n/app_localizations.dart';

/// A single navigation target shown by the adaptive shell.
typedef ShellDestination = ({
  String label,
  IconData icon,
  IconData selectedIcon,
});

/// Adaptive shell wrapping the five primary navigation branches.
///
/// The *logic* (destination set, ordering, indices) is defined exactly once;
/// only the *chrome* changes with the viewport:
///
/// * [WindowSizeClass.compact]  → Material bottom navigation bar
/// * [WindowSizeClass.medium]    → vertical navigation rail
/// * [WindowSizeClass.expanded]  → extended rail acting as a sidebar
///
/// This satisfies the responsive requirement without duplicating navigation
/// logic across breakpoints.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// Destinations shared by every chrome variant.
  static List<ShellDestination> destinations(BuildContext context) {
    final tr = context.tr;
    return [
      (
        label: tr.navDashboard,
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
      ),
      (
        label: tr.navOrders,
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long_rounded,
      ),
      (
        label: tr.navCatalog,
        icon: Icons.restaurant_menu_outlined,
        selectedIcon: Icons.restaurant_menu_rounded,
      ),
      (
        label: tr.navFinance,
        icon: Icons.account_balance_wallet_outlined,
        selectedIcon: Icons.account_balance_wallet_rounded,
      ),
      (
        label: tr.navMore,
        icon: Icons.more_horiz_rounded,
        selectedIcon: Icons.more_horiz_rounded,
      ),
    ];
  }

  void _goBranch(int index) {
    // goBranch preserves the state of every branch (scroll position, filters).
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizeClass, child) {
        switch (sizeClass) {
          case WindowSizeClass.compact:
            return Scaffold(
              body: child,
              bottomNavigationBar: _BottomBar(
                shell: navigationShell,
                onTap: _goBranch,
              ),
            );
          case WindowSizeClass.medium:
          case WindowSizeClass.expanded:
            return Scaffold(
              body: Row(
                children: [
                  _SideNavigation(
                    shell: navigationShell,
                    sizeClass: sizeClass,
                    onTap: _goBranch,
                  ),
                  Expanded(child: child!),
                ],
              ),
            );
        }
      },
      child: navigationShell,
    );
  }
}

/// Compact bottom navigation bar.
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.shell, required this.onTap});

  final StatefulNavigationShell shell;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final items = MainShell.destinations(context)
        .map(
          (d) => NavigationDestination(
            icon: Icon(d.icon),
            selectedIcon: Icon(d.selectedIcon),
            label: d.label,
          ),
        )
        .toList();

    return NavigationBar(
      selectedIndex: shell.currentIndex,
      onDestinationSelected: onTap,
      destinations: items,
    );
  }
}

/// Navigation rail used on tablet and desktop widths.
class _SideNavigation extends StatelessWidget {
  const _SideNavigation({
    required this.shell,
    required this.sizeClass,
    required this.onTap,
  });

  final StatefulNavigationShell shell;
  final WindowSizeClass sizeClass;
  final ValueChanged<int> onTap;

  bool get _extended => sizeClass.isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = MainShell.destinations(context)
        .map(
          (d) => NavigationRailDestination(
            icon: Icon(d.icon),
            selectedIcon: Icon(d.selectedIcon),
            label: Text(d.label),
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
        )
        .toList();

    return Container(
      width: _extended ? 240 : 72,
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: theme.dividerColor, width: 1)),
      ),
      // RTL: the rail must appear on the right edge, which [Directionality]
      // already handles for the row; the border mirrors accordingly.
      child: NavigationRail(
        extended: _extended,
        selectedIndex: shell.currentIndex,
        onDestinationSelected: onTap,
        labelType: _extended
            ? NavigationRailLabelType.none
            : NavigationRailLabelType.all,
        destinations: items,
        trailing: _extended
            ? Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  context.tr.appTitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
