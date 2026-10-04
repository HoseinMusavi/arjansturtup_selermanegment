import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/logging/app_logger.dart';
import '../../core/logging/log_level.dart';
import '../../core/security/session_manager.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/catalog/addons/presentation/addons_screen.dart';
import '../../features/catalog/categories/presentation/categories_screen.dart';
import '../../features/catalog/products/presentation/products_screen.dart';
import '../../features/catalog/sizes/presentation/sizes_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/finance/invoices/presentation/invoices_screen.dart';
import '../../features/finance/vouchers/presentation/vouchers_screen.dart';
import '../../features/more/presentation/more_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/reviews/presentation/reviews_screen.dart';
import '../../features/merchant_users/presentation/merchant_users_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import 'app_routes.dart';
import '../shell/main_shell.dart';

/// Builds the application [GoRouter].
///
/// Routing is declarative: the authenticated shell and the sign-in flow are
/// siblings, and [redirect] decides which one is reachable based on the
/// current [AuthState]. Navigation guards therefore live in exactly one place.
GoRouter buildAppRouter({
  required SessionManager sessionManager,
  required AppLogger logger,
}) {
  return GoRouter(
    initialLocation: AppRoutes.dashboardPath,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final authenticated = sessionManager.isAuthenticated;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      logger.log(
        level: LogLevel.trace,
        feature: 'routing',
        action: 'redirect',
        message: 'Evaluating redirect',
        context: {
          'authenticated': authenticated,
          'matchedLocation': state.matchedLocation,
        },
      );

      if (!authenticated && !isOnLogin) {
        return AppRoutes.login;
      }
      if (authenticated && isOnLogin) {
        return AppRoutes.dashboardPath;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Adaptive shell owning the five primary branches.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboardPath,
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.ordersPath,
                name: 'orders',
                builder: (context, state) => const OrdersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.catalogPath,
                name: 'catalog',
                builder: (context, state) => const ProductsScreen(),
                routes: [
                  GoRoute(
                    path: 'categories',
                    name: 'categories',
                    builder: (context, state) => const CategoriesScreen(),
                  ),
                  GoRoute(
                    path: 'sizes',
                    name: 'sizes',
                    builder: (context, state) => const SizesScreen(),
                  ),
                  GoRoute(
                    path: 'addons',
                    name: 'addons',
                    builder: (context, state) => const AddonsScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.financePath,
                name: 'finance',
                builder: (context, state) => const InvoicesScreen(),
                routes: [
                  GoRoute(
                    path: 'vouchers',
                    name: 'vouchers',
                    builder: (context, state) => const VouchersScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.morePath,
                name: 'more',
                builder: (context, state) => const MoreScreen(),
              ),
            ],
          ),
        ],
      ),

      // Secondary sections pushed from the "More" screen.
      GoRoute(
        path: AppRoutes.reviewsPath,
        name: 'reviews',
        builder: (context, state) => const ReviewsScreen(),
      ),
      GoRoute(
        path: AppRoutes.teamPath,
        name: 'team',
        builder: (context, state) => const MerchantUsersScreen(),
      ),
      GoRoute(
        path: AppRoutes.settingsPath,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => _RouteErrorScreen(error: state.error),
  );
}

/// Fallback rendered when navigation targets an unknown route.
class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('صفحه یافت نشد')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.map_outlined, size: 56),
              const SizedBox(height: 16),
              Text(
                'مسیر درخواستی وجود ندارد.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go(AppRoutes.dashboardPath),
                child: const Text('بازگشت به داشبورد'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
