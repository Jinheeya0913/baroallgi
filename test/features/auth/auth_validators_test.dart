import 'package:baroallgi/features/auth/auth_validators.dart';
import 'package:baroallgi/features/auth/egg_hashcode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validatePassword', () {
    test('rejects shorter than firebase auth minimum', () {
      expect(validatePassword('12345'), isNotNull);
    });

    test('accepts six or more characters', () {
      expect(validatePassword('123456'), isNull);
    });
  });

  group('generateEggHashcode', () {
    test('is six chars from safe alphabet', () {
      final code = generateEggHashcode();
      expect(code.length, eggHashcodeLength);
      expect(
        code.split('').every(eggHashcodeAlphabet.contains),
        isTrue,
      );
    });
  });
}
