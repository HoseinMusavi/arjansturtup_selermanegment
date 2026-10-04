/// Severity levels for structured application logging.
///
/// Ordered from least to most severe. The numeric value is used for
/// filtering at runtime (e.g. release builds only emit [warning] and above).
enum LogLevel {
  /// Very low-level internal tracing. Disabled in release builds.
  trace(0),

  /// Diagnostic information useful while developing.
  debug(1),

  /// Meaningful application milestones (e.g. "orders loaded").
  info(2),

  /// Recoverable situations that deserve attention.
  warning(3),

  /// A feature failed but the app remains usable.
  error(4),

  /// Unrecoverable condition; user cannot proceed.
  fatal(5);

  const LogLevel(this.weight);

  /// Comparable severity weight.
  final int weight;

  /// Whether this level is severe enough to be emitted in release builds.
  bool get emitsInRelease => weight >= warning.weight;

  /// Uppercase name used in serialized log output, e.g. `"ERROR"`.
  String get label => name.toUpperCase();
}
