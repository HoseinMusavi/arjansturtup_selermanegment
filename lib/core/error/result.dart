import 'app_failure.dart';

/// Discriminated union representing the outcome of a unit of work.
///
/// Using [Result] instead of throwing keeps call sites honest: repositories
/// and use cases declare failure as part of their signature, and the UI can
/// never be surprised by an exception. This removes scattered `try/catch`
/// blocks and makes error paths unit-testable.
///
/// Usage:
/// ```dart
/// Future<Result<List<Order>>> getOrders(PageQuery query) async {
///   try {
///     final dto = await _dataSource.fetchOrders(query);
///     return Success(dto.toDomain());
///   } on AppFailure catch (e) {
///     return Failure(e);
///   }
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// `true` when this is [Success].
  bool get isSuccess => this is Success<T>;

  /// `true` when this is [Failure].
  bool get isFailure => this is Failure<T>;

  /// The value when successful, otherwise `null`.
  T? get valueOrNull => switch (this) {
    Success(value: final v) => v,
    Failure() => null,
  };

  /// The failure when failed, otherwise `null`.
  AppFailure? get failureOrNull => switch (this) {
    Success() => null,
    Failure(failure: final f) => f,
  };

  /// Transforms the success value, leaving failures untouched.
  Result<R> map<R>(R Function(T value) mapper) => switch (this) {
    Success(value: final v) => Success(mapper(v)),
    Failure(failure: final f) => Failure(f),
  };

  /// Chains another result-producing operation on the success value.
  Result<R> flatMap<R>(Result<R> Function(T value) mapper) => switch (this) {
    Success(value: final v) => mapper(v),
    Failure(failure: final f) => Failure(f),
  };

  /// Returns the value or a fallback without inspecting the failure.
  T getOrElse(T Function(AppFailure failure) orElse) => switch (this) {
    Success(value: final v) => v,
    Failure(failure: final f) => orElse(f),
  };

  /// Functional pattern-match over both branches.
  R when<R>({
    required R Function(T value) success,
    required R Function(AppFailure failure) failure,
  }) => switch (this) {
    Success(value: final v) => success(v),
    Failure(failure: final f) => failure(f),
  };
}

/// Carries the successfully computed [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Success<T> && other.value == value);

  @override
  int get hashCode => Object.hash('Success', value);

  @override
  String toString() => 'Success($value)';
}

/// Carries the mapped, user-presentable [failure].
final class Failure<T> extends Result<T> {
  const Failure(this.failure);

  final AppFailure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Failure<T> && other.failure == failure);

  @override
  int get hashCode => Object.hash('Failure', failure);

  @override
  String toString() => 'Failure($failure)';
}
