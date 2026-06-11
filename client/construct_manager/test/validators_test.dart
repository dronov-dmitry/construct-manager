import 'package:flutter_test/flutter_test.dart';
import 'package:construct_manager/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns error for empty email', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('returns error for invalid email format', () {
      expect(Validators.email('notanemail'), isNotNull);
      expect(Validators.email('@domain.com'), isNotNull);
      expect(Validators.email('user@'), isNotNull);
    });

    test('returns null for valid email', () {
      expect(Validators.email('test@example.com'), isNull);
      expect(Validators.email('user.name@domain.co.uk'), isNull);
    });
  });

  group('Validators.password', () {
    test('returns error for empty password', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password(null), isNotNull);
    });

    test('returns error for short password', () {
      expect(Validators.password('1234567'), isNotNull);
    });

    test('returns null for valid password', () {
      expect(Validators.password('12345678'), isNull);
      expect(Validators.password('a'.padRight(20, 'b')), isNull);
    });
  });

  group('Validators.repeatPassword', () {
    test('returns error when passwords do not match', () {
      expect(Validators.repeatPassword('abc', 'def'), isNotNull);
    });

    test('returns null when passwords match', () {
      expect(Validators.repeatPassword('same', 'same'), isNull);
    });
  });

  group('Validators.number', () {
    test('returns error for non-numeric input', () {
      expect(Validators.number('abc'), isNotNull);
      expect(Validators.number(''), isNotNull);
      expect(Validators.number(null), isNotNull);
    });

    test('returns null for numeric input', () {
      expect(Validators.number('123'), isNull);
      expect(Validators.number('45.67'), isNull);
    });
  });
}
