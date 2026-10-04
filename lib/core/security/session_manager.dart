import 'package:equatable/equatable.dart';

/// Contract for holding and exposing legacy session credentials.
///
/// The backend authenticates with a mobile number + password and then expects
/// every subsequent request to carry a session token and a CSRF token. Those
/// credentials are the app's most sensitive material, therefore:
///
/// * Features **never** read tokens directly. They call repository methods and
///   the network layer attaches credentials through an interceptor.
/// * Implementations must persist credentials in secure storage only.
/// * Credentials must never appear in logs (see [LogSanitizer]).
///
/// Keeping this abstract lets Phase 0 ship a stub for the navigation shell
/// while the real, storage-backed implementation arrives with authentication.
abstract class SessionManager {
  /// Stream of authentication state changes.
  ///
  /// Emits immediately on subscription so listeners can render the current
  /// state without an extra request.
  Stream<AuthState> get authStateStream;

  /// The current authentication state without subscribing to the stream.
  AuthState get currentAuthState;

  /// Whether a usable session is available right now.
  bool get isAuthenticated;

  /// Session credential required by every authenticated request.
  ///
  /// Throws [StateError] when no session exists; callers must check
  /// [isAuthenticated] first. Exposed only to the network layer.
  String get sessionToken;

  /// CSRF credential required by every mutating request.
  String get csrfToken;

  /// Stores credentials obtained after a successful sign-in.
  Future<void> startSession({
    required String sessionToken,
    required String csrfToken,
  });

  /// Clears all stored credentials and emits the unauthenticated state.
  Future<void> clearSession();

  /// Disposes any resources held by the manager.
  void dispose();
}

/// Coarse-grained authentication state used by routing and the UI.
enum AuthStatus {
  /// No session is present; the user must sign in.
  unauthenticated,

  /// A session is present and believed to be valid.
  authenticated,

  /// The current session has been rejected by the backend (token rejected or
  /// expired); a re-sign-in is required.
  sessionExpired,
}

/// Immutable snapshot of the authentication state.
class AuthState extends Equatable {
  const AuthState({required this.status, this.merchantName});

  const AuthState.unauthenticated()
    : status = AuthStatus.unauthenticated,
      merchantName = null;

  const AuthState.authenticated({this.merchantName})
    : status = AuthStatus.authenticated;

  const AuthState.sessionExpired()
    : status = AuthStatus.sessionExpired,
      merchantName = null;

  final AuthStatus status;
  final String? merchantName;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isSessionExpired => status == AuthStatus.sessionExpired;

  AuthState copyWith({AuthStatus? status, String? merchantName}) {
    return AuthState(
      status: status ?? this.status,
      merchantName: merchantName ?? this.merchantName,
    );
  }

  @override
  List<Object?> get props => [status, merchantName];
}
