import 'package:flutter_test/flutter_test.dart';

import 'package:arjansturtup_selermanegment/core/logging/log_sanitizer.dart';

void main() {
  group('LogSanitizer', () {
    final sanitizer = LogSanitizer();

    test('redacts keys that name credentials', () {
      expect(sanitizer.isSensitiveKey('password'), isTrue);
      expect(sanitizer.isSensitiveKey('PASSWORD'), isTrue);
      expect(sanitizer.isSensitiveKey('yii_session_token'), isTrue);
      expect(sanitizer.isSensitiveKey('YII_CSRF_TOKEN'), isTrue);
      expect(sanitizer.isSensitiveKey('authorization'), isTrue);
      expect(sanitizer.isSensitiveKey('refresh_token'), isTrue);
      expect(sanitizer.isSensitiveKey('cookie'), isTrue);
      expect(sanitizer.isSensitiveKey('api_key'), isTrue);

      expect(sanitizer.isSensitiveKey('order_id'), isFalse);
      expect(sanitizer.isSensitiveKey('username'), isFalse);
    });

    test('redacts credential-looking values even without a known key', () {
      // 32 hex characters look like a Yii session token.
      final session = 'f9da51520ea3b854b3658b4f1e45354d';
      expect(sanitizer.sanitizeString(session), LogSanitizer.redacted);

      // 40 hex characters look like a Yii CSRF token.
      final csrf = '26bcc032ea14f108e70c063d304ba51ace149506';
      expect(sanitizer.sanitizeString(csrf), LogSanitizer.redacted);

      // Bearer schemes are stripped regardless of key name.
      expect(
        sanitizer.sanitizeString('Authorization: Bearer abc.def.ghi'),
        'Authorization: ${LogSanitizer.redacted}',
      );
    });

    test('leaves ordinary payload values untouched', () {
      expect(sanitizer.sanitizeString('orders'), 'orders');
      expect(sanitizer.sanitizeString('1,431,760 تومان'), '1,431,760 تومان');
    });

    test('scrubs nested maps and iterables', () {
      final input = {
        'action': 'merchantLogin',
        'username': '09120000000',
        'password': 'super-secret',
        'nested': {
          'yii_session_token': 'f9da51520ea3b854b3658b4f1e45354d',
          'ok': true,
        },
        'list': ['keep-me', '26bcc032ea14f108e70c063d304ba51ace149506'],
      };

      final result = sanitizer.sanitize(input) as Map<String, Object?>;

      expect(result['action'], 'merchantLogin');
      expect(result['username'], '09120000000');
      expect(result['password'], LogSanitizer.redacted);
      expect(
        (result['nested']! as Map)['yii_session_token'],
        LogSanitizer.redacted,
      );
      expect((result['nested']! as Map)['ok'], isTrue);
      expect((result['list']! as List).first, 'keep-me');
      expect((result['list']! as List).last, LogSanitizer.redacted);
    });

    test('sanitizes HTTP headers', () {
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'PHPSESSID=abcdef',
        'X-Request-Id': 'abc-123',
      };

      final result = sanitizer.sanitizeHeaders(headers);

      expect(result['Content-Type'], 'application/json');
      expect(result['Cookie'], LogSanitizer.redacted);
      expect(result['X-Request-Id'], 'abc-123');
    });

    test('null and non-string values pass through safely', () {
      expect(sanitizer.sanitize(null), isNull);
      expect(sanitizer.sanitize(42), 42);
      expect(sanitizer.sanitize(true), isTrue);
    });
  });
}
