/// Application-wide constants that are not secrets and not environment specific.
///
/// Anything that could differ between environments belongs in [AppConfig]
/// instead. Only well-known protocol identifiers and storage keys live here.
class AppConstants {
  AppConstants._();

  // --- Backend protocol -------------------------------------------------

  /// Query parameter that selects the backend action on the AJAX entry point.
  static const String actionParam = 'action';

  /// Legacy session credential parameter name. Never logged, never hardcoded.
  static const String sessionTokenParam = 'yii_session_token';

  /// Legacy CSRF credential parameter name. Never logged, never hardcoded.
  static const String csrfTokenParam = 'YII_CSRF_TOKEN';

  /// Controller context parameter sent with most requests.
  static const String currentControllerParam = 'currentController';

  /// Panel context parameter (`merchant`) sent with some list/delete requests.
  static const String currentPanelParam = 'current_panel';

  static const String currentPanelMerchant = 'merchant';

  /// Legacy backend success code shared by `{code, msg, details}` payloads.
  static const int codeSuccess = 1;

  /// Legacy code observed for "no result" *and* for error/rejection cases,
  /// therefore its meaning must be resolved per action.
  static const int codeNoResultOrError = 2;

  // --- Secure storage keys ----------------------------------------------

  /// Secure storage key for the persisted session credential.
  static const String sessionTokenKey = 'session_token';

  /// Secure storage key for the persisted CSRF credential.
  static const String csrfTokenKey = 'csrf_token';

  // --- HTTP semantics ---------------------------------------------------

  /// Header used to correlate a single request lifecycle end-to-end.
  static const String requestIdHeader = 'X-Request-Id';

  /// Locale code for the primary (Persian) locale.
  static const String persianLocale = 'fa';

  /// Locale code for the secondary (English) locale.
  static const String englishLocale = 'en';

  /// Persian thousands separator used by the backend when formatting money.
  static const String persianThousandsSeparator = ',';

  /// Currency suffix the backend appends to formatted amounts.
  static const String currencySuffix = 'تومان';

  /// Pattern of a valid Iranian mobile number as accepted by the login form.
  static const String mobilePattern = r'^09\d{9}$';
}
