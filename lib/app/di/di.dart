import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_config.dart';
import '../../core/logging/app_logger.dart';
import '../../core/logging/log_level.dart';
import '../../core/security/session_manager.dart';
import '../../core/security/stub_session_manager.dart';
import '../router/app_router.dart';

/// Global service locator.
///
/// Widgets and BLoCs resolve dependencies from here; they never construct
/// repositories or data sources themselves. Registration happens once in
/// [configureDependencies] (the composition root) during bootstrap.
final GetIt getIt = GetIt.instance;

/// Composition root that wires every application dependency.
///
/// Called once from bootstrap before the first frame. Each feature will
/// register its own repositories and data sources here as phases land.
Future<void> configureDependencies({
  AppConfig? config,
  AppLogger? logger,
}) async {
  final appConfig = config ?? const AppConfig.production();
  getIt.registerSingleton<AppConfig>(appConfig);

  // Reuse the bootstrap logger so startup and runtime records share a sink.
  final appLogger = logger ?? AppLogger(minLevel: _resolveMinLevel());
  if (!getIt.isRegistered<AppLogger>()) {
    getIt.registerSingleton<AppLogger>(appLogger);
  }

  // Session management is behind a contract. Phase 0 ships an in-memory stub;
  // the authentication phase replaces it with a secure-storage-backed
  // implementation without touching any consumer.
  //
  // Registered as a lazy singleton because it owns a broadcast stream that
  // must survive widget rebuilds but must be disposed at process shutdown.
  if (!getIt.isRegistered<SessionManager>()) {
    getIt.registerLazySingleton<SessionManager>(
      StubSessionManager.new,
      instanceName: null,
    );
  }

  // Routing depends on the session guard and the logger.
  getIt.registerSingleton<GoRouterProvider>(
    GoRouterProvider(
      sessionManager: getIt<SessionManager>(),
      logger: getIt<AppLogger>(),
    ),
  );

  appLogger.info(
    'Dependencies configured',
    feature: 'di',
    action: 'configure_dependencies',
    context: {
      'environment': appConfig.runtimeType.toString(),
      'minLogLevel': getIt<AppLogger>().minLevel.label,
    },
  );
}

/// Releases resources held by registered singletons (used in tests).
Future<void> resetDependencies() async {
  final sessionManager = getIt.isRegistered<SessionManager>()
      ? getIt<SessionManager>()
      : null;
  sessionManager?.dispose();
  await getIt.reset();
}

LogLevel _resolveMinLevel() {
  // Production builds must not emit chatty tracing; the release flag is
  // evaluated at compile time so verbose records are tree-shaken.
  const isRelease = bool.fromEnvironment('dart.vm.product');
  return isRelease ? LogLevel.warning : LogLevel.trace;
}

/// Thin wrapper that owns the [GoRouter] instance.
///
/// Exposing the router through `getIt` keeps [MaterialApp.router] declarative
/// and lets tests swap the whole navigation graph in one place.
class GoRouterProvider {
  GoRouterProvider({
    required SessionManager sessionManager,
    required AppLogger logger,
  }) : router = buildAppRouter(sessionManager: sessionManager, logger: logger);

  final GoRouter router;
}
