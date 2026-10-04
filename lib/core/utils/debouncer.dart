import 'dart:async';

/// Delays an action until [duration] elapses without another invocation.
///
/// Used by search inputs so a fast typist does not fire one network request
/// per keystroke. The pending callback is *cancellable*, which lets a search
/// field abandon an outdated request when the query changes again.
class Debouncer {
  Debouncer({this.duration = const Duration(milliseconds: 400)});

  /// Idle window that must pass before [run] fires.
  final Duration duration;

  Timer? _timer;

  /// Whether a callback is currently scheduled.
  bool get isActive => _timer?.isActive ?? false;

  /// Schedules [action], replacing any previously scheduled callback.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Cancels the pending callback without invoking it.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Releases the timer; call from `dispose`.
  void dispose() {
    cancel();
  }
}
