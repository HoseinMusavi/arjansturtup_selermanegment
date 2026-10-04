import 'package:flutter/foundation.dart';

/// Removes sensitive material from log payloads so that secrets never reach
/// any output stream (console, crash reporter, remote sink).
///
/// The legacy backend relies on session and CSRF credentials. Accidentally
/// logging them would allow session hijacking, therefore every log record is
/// passed through [sanitize] before it leaves the process.
class LogSanitizer {
  LogSanitizer({
    List<Pattern>? redactKeyPatterns,
    List<Pattern>? redactValuePatterns,
  }) : _redactKeyPatterns = redactKeyPatterns ?? _defaultKeyPatterns,
       _redactValuePatterns = redactValuePatterns ?? _defaultValuePatterns;

  /// Patterns matched against map keys (case-insensitive) and field names.
  final List<Pattern> _redactKeyPatterns;

  /// Patterns matched against raw string values (e.g. bearer tokens).
  final List<Pattern> _redactValuePatterns;

  /// Keys that must never be logged, matched case-insensitively.
  static final List<Pattern> _defaultKeyPatterns = [
    RegExp(r'password', caseSensitive: false),
    RegExp(r'passwd', caseSensitive: false),
    RegExp(r'authorization', caseSensitive: false),
    RegExp(r'auth_token', caseSensitive: false),
    RegExp(r'access_token', caseSensitive: false),
    RegExp(r'refresh_token', caseSensitive: false),
    RegExp(r'session_token', caseSensitive: false),
    RegExp(r'csrf', caseSensitive: false),
    RegExp(r'cookie', caseSensitive: false),
    RegExp(r'secret', caseSensitive: false),
    RegExp(r'api[_-]?key', caseSensitive: false),
    RegExp(r'otp', caseSensitive: false),
    RegExp(r'verification[_-]?code', caseSensitive: false),
  ];

  /// Value shapes that look like credentials even without a known key name.
  static final List<Pattern> _defaultValuePatterns = [
    // Yii session tokens: 32 hex characters.
    RegExp(r'\b[0-9a-f]{32}\b', caseSensitive: false),
    // Yii CSRF tokens: 40 hex characters.
    RegExp(r'\b[0-9a-f]{40}\b', caseSensitive: false),
    // Authorization header schemes.
    RegExp(r'Bearer\s+[A-Za-z0-9\-._~+/]+', caseSensitive: false),
  ];

  /// Fixed replacement text used for every redacted value.
  static const String redacted = '<redacted>';

  /// Returns [value] with any credential-looking content replaced.
  String sanitizeString(String value) {
    var result = value;
    for (final pattern in _redactValuePatterns) {
      result = result.replaceAllMapped(pattern, (_) => redacted);
    }
    return result;
  }

  /// Returns `true` when [key] names a sensitive field.
  bool isSensitiveKey(String key) {
    final lower = key.toLowerCase();
    return _redactKeyPatterns.any((p) => p.allMatches(lower).isNotEmpty);
  }

  /// Recursively scrubs a JSON-like structure in place and returns the cleaned
  /// copy. Nested [Map]s and [Iterable]s are traversed; [String] values are
  /// scanned for credential patterns as well.
  Object? sanitize(Object? value) {
    if (value is String) {
      return sanitizeString(value);
    }
    // Preserve String keys so a structured log context keeps its shape and the
    // result stays assignable to Map<String, Object?> for downstream consumers.
    if (value is Map<String, Object?>) {
      return value.map((key, entry) {
        if (isSensitiveKey(key)) {
          return MapEntry(key, redacted);
        }
        return MapEntry(key, sanitize(entry));
      });
    }
    if (value is Map) {
      return value.map<Object?, Object?>((key, entry) {
        final keyName = key?.toString() ?? '';
        if (isSensitiveKey(keyName)) {
          return MapEntry(key, redacted);
        }
        return MapEntry(key, sanitize(entry));
      });
    }
    if (value is Iterable) {
      return value.map(sanitize).toList();
    }
    return value;
  }

  /// Convenience wrapper used by [debugPrint]-style helpers.
  String sanitizeMessage(Object? message) {
    if (message == null) return '';
    if (message is String) return sanitizeString(message);
    return sanitizeString(message.toString());
  }

  /// Produces a redacted copy of HTTP headers for logging purposes.
  Map<String, dynamic> sanitizeHeaders(Map<String, dynamic> headers) {
    return headers.map((key, value) {
      if (isSensitiveKey(key)) {
        return MapEntry(key, redacted);
      }
      return MapEntry(key, sanitize(value));
    });
  }
}
