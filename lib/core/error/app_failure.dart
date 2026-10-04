import 'package:equatable/equatable.dart';

/// Base type for every failure the UI may need to render.
///
/// The presentation layer only ever sees [AppFailure] subtypes — never raw
/// [Exception]s or backend error payloads. Each subtype carries a
/// user-friendly Persian [message] plus a stable [typeLabel] used for logging
/// and analytics, and optional [fieldErrors] for form validation cases.
///
/// Adding a new failure means extending this sealed hierarchy and mapping it
/// from the data layer, keeping error handling centralized and predictable.
sealed class AppFailure extends Equatable {
  const AppFailure({
    required this.message,
    this.code,
    this.fieldErrors = const {},
    this.cause,
  });

  /// Human readable message safe to display to the merchant.
  final String message;

  /// Stable machine identifier, e.g. `ServerFailure`. Used in logs.
  String get typeLabel;

  /// Optional backend status/protocol code that produced the failure.
  final int? code;

  /// Field-level validation messages keyed by the domain field name.
  final Map<String, String> fieldErrors;

  /// The original error, kept for diagnostics in debug builds only.
  final Object? cause;

  /// Whether retrying the same operation could plausibly succeed.
  bool get isRetryable => false;

  /// Whether the user must re-authenticate to proceed.
  bool get requiresReauthentication => false;

  @override
  List<Object?> get props => [message, typeLabel, code, fieldErrors];
}

/// The device has no usable connectivity, or the request never reached the
/// server (e.g. DNS failure, connection refused).
class NetworkFailure extends AppFailure {
  const NetworkFailure({
    super.message = 'اتصال اینترنت برقرار نیست. لطفاً اتصال خود را بررسی کنید.',
    super.cause,
  });

  @override
  String get typeLabel => 'NetworkFailure';

  @override
  bool get isRetryable => true;
}

/// The request took longer than the configured timeout.
class TimeoutFailure extends AppFailure {
  const TimeoutFailure({
    super.message = 'پاسخ سرور بیش از حد طول کشید. دوباره تلاش کنید.',
    super.cause,
  });

  @override
  String get typeLabel => 'TimeoutFailure';

  @override
  bool get isRetryable => true;
}

/// The session is missing, invalid or expired. The merchant must sign in again.
class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure({
    super.message = 'نشست شما به پایان رسیده است. لطفاً دوباره وارد شوید.',
    super.cause,
  });

  @override
  String get typeLabel => 'UnauthorizedFailure';

  @override
  bool get requiresReauthentication => true;
}

/// The account exists but is not permitted to perform this operation.
class ForbiddenFailure extends AppFailure {
  const ForbiddenFailure({
    super.message = 'شما اجازه انجام این عملیات را ندارید.',
    super.cause,
  });

  @override
  String get typeLabel => 'ForbiddenFailure';
}

/// The server rejected the payload. [fieldErrors] carries per-field reasons.
class ValidationFailure extends AppFailure {
  const ValidationFailure({
    super.message = 'اطلاعات وارد شده معتبر نیست.',
    super.fieldErrors = const {},
    super.cause,
  });

  @override
  String get typeLabel => 'ValidationFailure';
}

/// The server returned an error status (5xx) or a well-formed error payload.
class ServerFailure extends AppFailure {
  const ServerFailure({
    super.message = 'خطای سرور. لطفاً کمی بعد دوباره تلاش کنید.',
    super.code,
    super.cause,
  });

  @override
  String get typeLabel => 'ServerFailure';

  @override
  bool get isRetryable => true;
}

/// The response could not be interpreted (malformed JSON, unexpected shape or
/// an HTML page where structured data was expected).
class ParsingFailure extends AppFailure {
  const ParsingFailure({
    super.message = 'پاسخ دریافتی از سرور قابل تفسیر نیست.',
    super.cause,
  });

  @override
  String get typeLabel => 'ParsingFailure';
}

/// Local session storage is unavailable or corrupted.
class SessionFailure extends AppFailure {
  const SessionFailure({
    super.message = 'ذخیره‌سازی نشست با مشکل مواجه شد.',
    super.cause,
  });

  @override
  String get typeLabel => 'SessionFailure';

  @override
  bool get requiresReauthentication => true;
}

/// A media upload was rejected or failed mid-transfer.
class UploadFailure extends AppFailure {
  const UploadFailure({
    super.message = 'بارگذاری فایل ناموفق بود.',
    super.code,
    super.cause,
  });

  @override
  String get typeLabel => 'UploadFailure';

  @override
  bool get isRetryable => true;
}

/// The operation was cancelled (e.g. a newer search superseded an older one).
class CancelledFailure extends AppFailure {
  const CancelledFailure({super.message = 'درخواست لغو شد.', super.cause});

  @override
  String get typeLabel => 'CancelledFailure';
}

/// Anything we could not classify. Treated as non-retryable by default to
/// avoid hammering the server for an unknown condition.
class UnknownFailure extends AppFailure {
  const UnknownFailure({super.message = 'خطای ناشناخته رخ داد.', super.cause});

  @override
  String get typeLabel => 'UnknownFailure';
}
