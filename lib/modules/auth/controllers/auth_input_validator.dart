import 'package:get/get.dart';

class AuthInputValidator {
  const AuthInputValidator._();

  static String? validateCredentials(String email, String password) {
    if (email.trim().isEmpty) return 'Enter your email address.';
    if (password.isEmpty) return 'Enter your password.';
    if (!GetUtils.isEmail(email.trim())) return 'Enter a valid email address.';
    if (password.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }

  static String? validatePasswordConfirmation(
    String password,
    String confirmation,
  ) {
    if (confirmation.isEmpty) return 'Confirm your password.';
    if (password != confirmation) return 'Passwords do not match.';
    return null;
  }
}
