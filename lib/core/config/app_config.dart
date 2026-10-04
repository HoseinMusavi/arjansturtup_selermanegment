/// Immutable, environment-driven application configuration.
///
/// The legacy backend host is public information (the merchant panel origin);
/// it is *not* a secret. Real secrets — session and CSRF tokens — are never
/// stored here; they are fetched at runtime and kept in secure storage only.
///
/// Values can be overridden per environment or in tests via [AppConfig.custom]
/// so that no feature reaches for string literals at runtime.
class AppConfig {
  const AppConfig({
    required this.baseUrl,
    required this.ajaxMerchantPath,
    required this.uploadSinglePath,
    required this.uploadMultiplePath,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
    required this.defaultPageSize,
    required this.pollingIntervalSeconds,
    required this.maxImageUploadBytes,
  });

  /// Configuration targeting the production legacy backend.
  const AppConfig.production()
    : baseUrl = 'https://arjanapp.ir',
      ajaxMerchantPath = '/ajaxmerchant',
      uploadSinglePath = '/ajaxmerchant/uploadFile/',
      uploadMultiplePath = '/ajaxmerchant/MultipleUploadFile/',
      connectTimeout = const Duration(seconds: 15),
      receiveTimeout = const Duration(seconds: 30),
      sendTimeout = const Duration(seconds: 30),
      defaultPageSize = 15,
      pollingIntervalSeconds = 21,
      maxImageUploadBytes = 10 * 1024 * 1024; // 10MB (server-side limit)

  /// Configuration used by widget and integration tests. Points at a
  /// non-routable host so accidental network access fails loudly.
  const AppConfig.test()
    : baseUrl = 'http://localhost:0',
      ajaxMerchantPath = '/ajaxmerchant',
      uploadSinglePath = '/ajaxmerchant/uploadFile/',
      uploadMultiplePath = '/ajaxmerchant/MultipleUploadFile/',
      connectTimeout = const Duration(seconds: 2),
      receiveTimeout = const Duration(seconds: 2),
      sendTimeout = const Duration(seconds: 2),
      defaultPageSize = 15,
      pollingIntervalSeconds = 3600,
      maxImageUploadBytes = 10 * 1024 * 1024;

  /// Builds a derived configuration, useful for environment overrides.
  AppConfig.custom(
    AppConfig base, {
    String? baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    int? defaultPageSize,
  }) : baseUrl = baseUrl ?? base.baseUrl,
       ajaxMerchantPath = base.ajaxMerchantPath,
       uploadSinglePath = base.uploadSinglePath,
       uploadMultiplePath = base.uploadMultiplePath,
       connectTimeout = connectTimeout ?? base.connectTimeout,
       receiveTimeout = receiveTimeout ?? base.receiveTimeout,
       sendTimeout = base.sendTimeout,
       defaultPageSize = defaultPageSize ?? base.defaultPageSize,
       pollingIntervalSeconds = base.pollingIntervalSeconds,
       maxImageUploadBytes = base.maxImageUploadBytes;

  /// Origin of the legacy merchant backend.
  final String baseUrl;

  /// Path of the single AJAX entry point used by every action.
  final String ajaxMerchantPath;

  /// Path of the single-image upload endpoint.
  final String uploadSinglePath;

  /// Path of the multi-image (gallery) upload endpoint.
  final String uploadMultiplePath;

  /// Full URL of the AJAX entry point.
  String get ajaxMerchantUrl => '$baseUrl$ajaxMerchantPath';

  /// Full URL of the single-image upload endpoint.
  String get uploadSingleUrl => '$baseUrl$uploadSinglePath';

  /// Full URL of the multi-image upload endpoint.
  String get uploadMultipleUrl => '$baseUrl$uploadMultiplePath';

  /// TCP connection establishment budget.
  final Duration connectTimeout;

  /// Budget for receiving the full response body.
  final Duration receiveTimeout;

  /// Budget for sending the full request body.
  final Duration sendTimeout;

  /// Page size used for server-side list endpoints.
  final int defaultPageSize;

  /// Interval used by dashboard polling signals (new order / new booking).
  final int pollingIntervalSeconds;

  /// Maximum accepted image size, mirroring the server-side limit.
  final int maxImageUploadBytes;
}
