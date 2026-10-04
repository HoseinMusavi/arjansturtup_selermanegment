import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import '../../core/logging/app_logger.dart';
import '../../core/logging/log_level.dart';
import '../app.dart';
import '../di/di.dart';

/// Application startup sequence.
///
/// Ordering matters: error capture and logging must come online first so that
/// every subsequent step (dependency wiring, first frame) is observable, and
/// the UI never renders before its dependencies exist.
Future<Widget> bootstrap({
  AppConfig config = const AppConfig.production(),
}) async {
  // 1. Structural logging comes online first so every subsequent step is
  //    observable, including failures inside dependency wiring.
  final logger = AppLogger(minLevel: _resolveMinLevel());

  // 2. Capture framework-level errors as early as possible.
  _installErrorHandlers(logger);

  logger.info(
    'Bootstrap started',
    feature: 'bootstrap',
    action: 'start',
    context: {'environment': config.runtimeType.toString()},
  );

  // 3. Make sure Flutter binding services are ready before async work.
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Composition root: register config, logger, session guard and router.
  await configureDependencies(config: config, logger: logger);

  logger.info('Bootstrap complete', feature: 'bootstrap', action: 'complete');

  return const App();
}

LogLevel _resolveMinLevel() {
  const isRelease = bool.fromEnvironment('dart.vm.product');
  return isRelease ? LogLevel.warning : LogLevel.trace;
}

void _installErrorHandlers(AppLogger logger) {
  // Framework errors (build/layout failures) must never show the raw red
  // screen to a merchant; they are logged and replaced with a neutral widget.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logger.failure(
      'Framework error during rendering',
      errorType: 'FlutterError',
      feature: 'bootstrap',
      error: details.exception,
      stackTrace: details.stack,
      context: {'library': details.library ?? 'unknown'},
    );
  };

  // Errors thrown outside the widget tree (isolates, futures).
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.failure(
      'Uncaught platform error',
      errorType: error.runtimeType.toString(),
      feature: 'bootstrap',
      error: error,
      stackTrace: stack,
    );
    return true;
  };

  // Replace the default error widget (red screen) with a calm fallback.
  ErrorWidget.builder = (details) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 40),
              const SizedBox(height: 12),
              Text(
                'بخشی از صفحه بارگذاری نشد.',
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 8),
                Text(
                  details.exception.toString(),
                  style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  };
}
