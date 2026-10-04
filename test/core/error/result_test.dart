import 'package:flutter_test/flutter_test.dart';

import 'package:arjansturtup_selermanegment/core/error/app_failure.dart';
import 'package:arjansturtup_selermanegment/core/error/result.dart';

void main() {
  group('Result', () {
    test('Success carries its value', () {
      const result = Success<int>(42);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.valueOrNull, 42);
      expect(result.failureOrNull, isNull);
    });

    test('Failure carries the mapped failure', () {
      const failure = ServerFailure();
      final result = Failure<int>(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.valueOrNull, isNull);
      expect(result.failureOrNull, failure);
    });

    test('map transforms the success value only', () {
      const result = Success<int>(10);
      final mapped = result.map((value) => value * 2);

      expect(mapped.valueOrNull, 20);
    });

    test('map leaves failures untouched', () {
      const failure = NetworkFailure();
      final result = Failure<int>(failure);
      final mapped = result.map((value) => value * 2);

      expect(mapped.failureOrNull, failure);
      expect(mapped.valueOrNull, isNull);
    });

    test('flatMap chains operations and short-circuits on failure', () {
      const success = Success<int>(5);
      final chained = success.flatMap((value) => Success<String>('v=$value'));
      expect(chained.valueOrNull, 'v=5');

      const failure = Failure<int>(TimeoutFailure());
      final shortCircuit = failure.flatMap(
        (value) => Success<String>('v=$value'),
      );
      expect(shortCircuit.isFailure, isTrue);
    });

    test('getOrElse provides a fallback', () {
      const failure = Failure<int>(UnknownFailure());
      expect(failure.getOrElse((f) => -1), -1);

      const success = Success<int>(7);
      expect(success.getOrElse((f) => -1), 7);
    });

    test('when visits the correct branch', () {
      const success = Success<int>(3);
      expect(
        success.when(success: (v) => 'ok:$v', failure: (f) => 'fail'),
        'ok:3',
      );

      const failure = Failure<int>(ValidationFailure());
      expect(
        failure.when(success: (v) => 'ok:$v', failure: (f) => 'fail'),
        'fail',
      );
    });

    test('equality is based on content', () {
      const a = Success<int>(1);
      const b = Success<int>(1);
      const c = Success<int>(2);

      expect(a, b);
      expect(a == c, isFalse);

      const d = Failure<int>(NetworkFailure());
      const e = Failure<int>(NetworkFailure());
      expect(d, e);
    });
  });

  group('AppFailure', () {
    test('server and network failures are retryable', () {
      expect(const ServerFailure().isRetryable, isTrue);
      expect(const NetworkFailure().isRetryable, isTrue);
      expect(const TimeoutFailure().isRetryable, isTrue);
      expect(const UploadFailure().isRetryable, isTrue);
    });

    test('validation and parsing failures are not retryable', () {
      expect(const ValidationFailure().isRetryable, isFalse);
      expect(const ParsingFailure().isRetryable, isFalse);
      expect(const UnknownFailure().isRetryable, isFalse);
    });

    test('unauthorized failure requests re-authentication', () {
      expect(const UnauthorizedFailure().requiresReauthentication, isTrue);
      expect(const SessionFailure().requiresReauthentication, isTrue);
      expect(const ForbiddenFailure().requiresReauthentication, isFalse);
    });

    test('each subtype exposes a stable type label', () {
      expect(const NetworkFailure().typeLabel, 'NetworkFailure');
      expect(const TimeoutFailure().typeLabel, 'TimeoutFailure');
      expect(const UnauthorizedFailure().typeLabel, 'UnauthorizedFailure');
      expect(const ForbiddenFailure().typeLabel, 'ForbiddenFailure');
      expect(const ValidationFailure().typeLabel, 'ValidationFailure');
      expect(const ServerFailure().typeLabel, 'ServerFailure');
      expect(const ParsingFailure().typeLabel, 'ParsingFailure');
      expect(const SessionFailure().typeLabel, 'SessionFailure');
      expect(const UploadFailure().typeLabel, 'UploadFailure');
      expect(const CancelledFailure().typeLabel, 'CancelledFailure');
      expect(const UnknownFailure().typeLabel, 'UnknownFailure');
    });

    test('messages are non-empty Persian strings', () {
      final messages = [
        const NetworkFailure().message,
        const TimeoutFailure().message,
        const UnauthorizedFailure().message,
        const ForbiddenFailure().message,
        const ValidationFailure().message,
        const ServerFailure().message,
        const ParsingFailure().message,
        const SessionFailure().message,
        const UploadFailure().message,
        const CancelledFailure().message,
        const UnknownFailure().message,
      ];

      for (final message in messages) {
        expect(message, isNotEmpty);
      }
    });

    test('validation failure carries field errors', () {
      const failure = ValidationFailure(
        fieldErrors: {'email': 'ایمیل الزامی است.'},
      );

      expect(failure.fieldErrors['email'], 'ایمیل الزامی است.');
    });
  });
}
