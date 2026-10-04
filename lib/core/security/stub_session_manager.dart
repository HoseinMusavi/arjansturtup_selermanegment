import 'dart:async';

import 'session_manager.dart';

/// Temporary in-memory [SessionManager] used only while the real
/// authentication phase has not landed.
///
/// It holds a single authenticated state so that navigation, routing and the
/// adaptive shell can be exercised end to end in Phase 0. This class is
/// intentionally replaced by a secure-storage-backed implementation that
/// performs the real session bootstrap (fetching credentials from the login
/// page). **Do not extend or reuse it in production code paths.**
class StubSessionManager implements SessionManager {
  StubSessionManager({AuthState initialState = const AuthState.authenticated()})
    : _state = initialState;

  AuthState _state;
  final StreamController<AuthState> _controller =
      StreamController<AuthState>.broadcast();

  @override
  Stream<AuthState> get authStateStream {
    // Emit the current state immediately so listeners can render without an
    // extra round trip.
    _controller.add(_state);
    return _controller.stream;
  }

  @override
  AuthState get currentAuthState => _state;

  @override
  bool get isAuthenticated => _state.isAuthenticated;

  @override
  String get sessionToken {
    if (!isAuthenticated) {
      throw StateError('No active session; credentials are unavailable.');
    }
    return '';
  }

  @override
  String get csrfToken {
    if (!isAuthenticated) {
      throw StateError('No active session; credentials are unavailable.');
    }
    return '';
  }

  @override
  Future<void> startSession({
    required String sessionToken,
    required String csrfToken,
  }) async {
    _state = const AuthState.authenticated();
    _controller.add(_state);
  }

  @override
  Future<void> clearSession() async {
    _state = const AuthState.unauthenticated();
    _controller.add(_state);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
