import 'package:flutter_test/flutter_test.dart';

import 'package:arjansturtup_selermanegment/core/logging/app_logger.dart';
import 'package:arjansturtup_selermanegment/core/logging/log_event.dart';
import 'package:arjansturtup_selermanegment/core/logging/log_level.dart';

void main() {
  group('AppLogger', () {
    test('emits records at or above the minimum level', () {
      final logger = AppLogger(minLevel: LogLevel.warning);

      logger.info('should be dropped');
      logger.warning('should be kept');
      logger.failure('also kept', errorType: 'NetworkFailure');

      expect(logger.recordedEvents, hasLength(2));
      expect(logger.recordedEvents.first.level, LogLevel.warning);
      expect(logger.recordedEvents.last.level, LogLevel.error);
    });

    test('isEnabled reflects the threshold', () {
      final logger = AppLogger(minLevel: LogLevel.error);

      expect(logger.isEnabled(LogLevel.fatal), isTrue);
      expect(logger.isEnabled(LogLevel.error), isTrue);
      expect(logger.isEnabled(LogLevel.info), isFalse);
      expect(logger.isEnabled(LogLevel.trace), isFalse);
    });

    test('setMinLevel raises the threshold retroactively', () {
      final logger = AppLogger(minLevel: LogLevel.trace);
      logger.setMinLevel(LogLevel.error);

      // The setMinLevel call itself emits a debug record which is now dropped.
      logger.debug('dropped');
      logger.failure('kept', errorType: 'X');

      final levels = logger.recordedEvents.map((event) => event.level).toList();
      expect(levels, contains(LogLevel.error));
      expect(levels, isNot(contains(LogLevel.debug)));
    });

    test('carries semantic context through to the record', () {
      final logger = AppLogger(minLevel: LogLevel.trace);

      logger.info(
        'Fetched orders',
        feature: 'orders',
        action: 'fetch_orders',
        requestId: 'req-1',
        durationMs: 320,
        context: {'page': 2, 'total': 41},
      );

      final event = logger.recordedEvents.single;
      expect(event.feature, 'orders');
      expect(event.action, 'fetch_orders');
      expect(event.requestId, 'req-1');
      expect(event.durationMs, 320);
      expect(event.context['page'], 2);
      expect(event.context['total'], 41);
    });

    test('preserves the whole context map (regression)', () {
      // sanitize() used to widen map keys to Object?, which made the
      // is-Map<String,Object?> guard in log() fail and silently drop *every*
      // structured field. This test pins the correct behaviour.
      final logger = AppLogger(minLevel: LogLevel.trace);

      logger.info('test', context: {'a': 1, 'b': 'two', 'c': true});

      expect(logger.recordedEvents.single.context, {
        'a': 1,
        'b': 'two',
        'c': true,
      });
    });

    test('redacts credentials inside context and message', () {
      final logger = AppLogger(minLevel: LogLevel.trace);

      logger.info(
        'Logging in with token f9da51520ea3b854b3658b4f1e45354d',
        context: {
          'username': '09120000000',
          'password': 'hunter2',
          'YII_CSRF_TOKEN': '26bcc032ea14f108e70c063d304ba51ace149506',
        },
      );

      final event = logger.recordedEvents.single;

      expect(event.context['username'], '09120000000');
      expect(event.context['password'], '<redacted>');
      expect(event.context['YII_CSRF_TOKEN'], '<redacted>');
      expect(event.message, 'Logging in with token <redacted>');
    });

    test('forwards records to the injected sink', () {
      final collected = <LogEvent>[];
      final logger = AppLogger(minLevel: LogLevel.trace, sink: collected.add);

      logger.info('hello');

      expect(collected, hasLength(1));
      expect(collected.single.message, 'hello');
    });

    test('clear resets retained records', () {
      final logger = AppLogger(minLevel: LogLevel.trace);
      logger.info('one');
      logger.reset();

      expect(logger.recordedEvents, isEmpty);
    });
  });
}
