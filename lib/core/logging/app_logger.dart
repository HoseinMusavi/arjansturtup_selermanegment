import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import 'log_event.dart';
import 'log_level.dart';
import 'log_sanitizer.dart';

/// Central structured logging entry point.
///
/// Design goals:
/// * One application-wide API so features never reach for `print` or
///   `developer.log` directly.
/// * Every payload is sanitized so that session/CSRF credentials and passwords
///   can never be emitted.
/// * Verbose levels are dropped in release builds automatically.
/// * Testable: the output sink is injectable and captured records are
///   collectable via [recordedEvents].
class AppLogger {
  AppLogger({
    LogSanitizer? sanitizer,
    LogLevel minLevel = LogLevel.trace,
    void Function(LogEvent)? sink,
  }) : _sanitizer = sanitizer ?? LogSanitizer(),
       _minLevel = minLevel,
       _sink = sink;

  final LogSanitizer _sanitizer;
  LogLevel _minLevel;
  final void Function(LogEvent)? _sink;

  /// Records emitted since the logger was created (bounded).
  final List<LogEvent> recordedEvents = [];

  /// Maximum number of in-memory records retained for diagnostics.
  static const int _maxRecorded = 500;

  /// Minimum severity that will actually be emitted.
  LogLevel get minLevel => _minLevel;

  /// Allows bootstrap to raise the threshold for release builds.
  void setMinLevel(LogLevel level) {
    _minLevel = level;
    log(
      level: LogLevel.debug,
      feature: 'logging',
      action: 'set_min_level',
      message: 'Minimum log level set to ${level.label}',
    );
  }

  /// Whether a record at [level] would be emitted right now.
  bool isEnabled(LogLevel level) => level.weight >= _minLevel.weight;

  /// Main entry point. All convenience methods funnel through here.
  void log({
    required LogLevel level,
    required String message,
    String? feature,
    String? action,
    String? requestId,
    int? durationMs,
    String? errorType,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    if (!isEnabled(level)) return;

    // Sanitize context defensively; the message is sanitized too so that
    // interpolated credentials (e.g. a URL query token) cannot leak.
    final Object? safeContext = _sanitizer.sanitize(context);
    final safeMessage = _sanitizer.sanitizeMessage(message);

    final event = LogEvent(
      level: level,
      message: safeMessage,
      feature: feature,
      action: action,
      requestId: requestId,
      durationMs: durationMs,
      errorType: errorType,
      error: kDebugMode ? error : null,
      stackTrace: kDebugMode ? stackTrace : null,
      context: safeContext is Map<String, Object?>
          ? Map<String, Object?>.from(safeContext)
          : const <String, Object?>{},
    );

    _record(event);
  }

  void _record(LogEvent event) {
    recordedEvents.add(event);
    if (recordedEvents.length > _maxRecorded) {
      recordedEvents.removeAt(0);
    }

    _sink?.call(event);
    _writeToConsole(event);
  }

  void _writeToConsole(LogEvent event) {
    final encoded = event.toJson();
    final payload = encoded.entries
        .where((e) => e.value != null)
        .map((e) => '${e.key}=${e.value}')
        .join(' ');

    developer.log(
      payload,
      name: 'arjan.${event.feature ?? 'app'}',
      level: _dartLevel(event.level),
      error: event.error,
      stackTrace: event.stackTrace,
    );
  }

  int _dartLevel(LogLevel level) {
    switch (level) {
      case LogLevel.trace:
        return 300;
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.fatal:
        return 1200;
    }
  }

  // --- Convenience API -------------------------------------------------

  void trace(
    String message, {
    String? feature,
    String? action,
    String? requestId,
    Map<String, Object?> context = const {},
  }) => log(
    level: LogLevel.trace,
    message: message,
    feature: feature,
    action: action,
    requestId: requestId,
    context: context,
  );

  void debug(
    String message, {
    String? feature,
    String? action,
    String? requestId,
    Map<String, Object?> context = const {},
  }) => log(
    level: LogLevel.debug,
    message: message,
    feature: feature,
    action: action,
    requestId: requestId,
    context: context,
  );

  void info(
    String message, {
    String? feature,
    String? action,
    String? requestId,
    int? durationMs,
    Map<String, Object?> context = const {},
  }) => log(
    level: LogLevel.info,
    message: message,
    feature: feature,
    action: action,
    requestId: requestId,
    durationMs: durationMs,
    context: context,
  );

  void warning(
    String message, {
    String? feature,
    String? action,
    String? requestId,
    Map<String, Object?> context = const {},
  }) => log(
    level: LogLevel.warning,
    message: message,
    feature: feature,
    action: action,
    requestId: requestId,
    context: context,
  );

  /// Records a failure. Prefer passing the mapped [errorType] string so the
  /// record stays useful for aggregated crash analytics.
  void failure(
    String message, {
    required String errorType,
    String? feature,
    String? action,
    String? requestId,
    int? durationMs,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) => log(
    level: LogLevel.error,
    message: message,
    feature: feature,
    action: action,
    requestId: requestId,
    durationMs: durationMs,
    errorType: errorType,
    error: error,
    stackTrace: stackTrace,
    context: context,
  );

  void fatal(
    String message, {
    required String errorType,
    String? feature,
    String? action,
    String? requestId,
    Object? error,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) => log(
    level: LogLevel.fatal,
    message: message,
    feature: feature,
    action: action,
    requestId: requestId,
    errorType: errorType,
    error: error,
    stackTrace: stackTrace,
    context: context,
  );

  /// Clears retained records (used between tests).
  @visibleForTesting
  void reset() => recordedEvents.clear();
}
