import 'package:flutter_test/flutter_test.dart';
import 'package:weather_application/modules/auth/controllers/auth_input_validator.dart';

void main() {
  test(
    'validates required email, email format, and minimum password length',
    () {
      expect(
        AuthInputValidator.validateCredentials('', ''),
        'Enter your email address.',
      );
      expect(
        AuthInputValidator.validateCredentials('person@example.com', ''),
        'Enter your password.',
      );
      expect(
        AuthInputValidator.validateCredentials('not-an-email', 'password123'),
        'Enter a valid email address.',
      );
      expect(
        AuthInputValidator.validateCredentials('person@example.com', '123'),
        'Password must be at least 6 characters.',
      );
      expect(
        AuthInputValidator.validateCredentials(
          'person@example.com',
          'secure123',
        ),
        isNull,
      );
    },
  );

  test('validates registration password confirmation', () {
    expect(
      AuthInputValidator.validatePasswordConfirmation('secure123', ''),
      'Confirm your password.',
    );
    expect(
      AuthInputValidator.validatePasswordConfirmation('secure123', 'different'),
      'Passwords do not match.',
    );
    expect(
      AuthInputValidator.validatePasswordConfirmation('secure123', 'secure123'),
      isNull,
    );
  });
}
