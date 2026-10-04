import 'package:equatable/equatable.dart';

import 'log_level.dart';

/// A single structured log record.
///
/// Records carry the semantic context of the feature that produced them so
/// that output stays useful in aggregate (filtering by feature, correlating a
/// request lifecycle by [requestId], measuring work by [durationMs]).
///
/// Sensitive fields must already be redacted by [LogSanitizer] before a
/// [LogEvent] is constructed.
class LogEvent extends Equatable {
  const LogEvent({
    required this.level,
    required this.message,
    this.feature,
    this.action,
    this.requestId,
    this.durationMs,
    this.errorType,
    this.error,
    this.stackTrace,
    this.context = const {},
  });

  /// Severity of the record.
  final LogLevel level;

  /// Human readable, already-sanitized primary message.
  final String message;

  /// Feature namespace, e.g. `orders`, `auth`, `network`.
  final String? feature;

  /// Action in progress, e.g. `update_order_status`.
  final String? action;

  /// Correlates the record with a single API request lifecycle.
  final String? requestId;

  /// Elapsed time of the measured operation, when applicable.
  final int? durationMs;

  /// Stable identifier of the failure type, e.g. `ServerFailure`.
  final String? errorType;

  /// Original error object (kept for debug builds only).
  final Object? error;

  /// Optional stack trace (kept for debug builds only).
  final StackTrace? stackTrace;

  /// Additional sanitized structured fields.
  final Map<String, Object?> context;

  /// Serializes the record to a JSON-like map for structured sinks.
  Map<String, Object?> toJson() {
    return {
      'level': level.label,
      'feature': feature,
      'action': action,
      'requestId': requestId,
      'message': message,
      'durationMs': durationMs,
      'errorType': errorType,
      if (context.isNotEmpty) 'context': context,
    };
  }

  @override
  List<Object?> get props => [
    level,
    message,
    feature,
    action,
    requestId,
    durationMs,
    errorType,
    context,
  ];
}
