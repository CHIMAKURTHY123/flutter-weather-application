import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../data/services/auth_service.dart';

class AuthController extends GetxController {
  AuthController({AuthService? service}) : _service = service ?? AuthService();
  final AuthService _service;
  final user = Rxn<User>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  StreamSubscription<User?>? _subscription;

  @override
  void onInit() {
    super.onInit();
    user.value = _service.currentUser;
    _subscription = _service.authStateChanges.listen(
      (value) => user.value = value,
    );
  }

  bool validateCredentials(String email, String password) {
    if (!GetUtils.isEmail(email.trim())) {
      errorMessage.value = 'Enter a valid email address.';
      return false;
    }
    if (password.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters.';
      return false;
    }
    return true;
  }

  Future<bool> login(String email, String password) async {
    if (!validateCredentials(email, password)) return false;
    return _run(() => _service.login(email, password));
  }

  Future<bool> register(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (!validateCredentials(email, password)) return false;
    if (password != confirmPassword) {
      errorMessage.value = 'Passwords do not match.';
      return false;
    }
    return _run(() => _service.register(email, password));
  }

  Future<bool> _run(Future<Object?> Function() action) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await action();
      return true;
    } on FirebaseAuthException catch (error) {
      errorMessage.value = switch (error.code) {
        'invalid-email' => 'That email address is not valid.',
        'user-disabled' => 'This account has been disabled.',
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' => 'Email or password is incorrect.',
        'email-already-in-use' => 'An account already exists for this email.',
        'weak-password' =>
          'Choose a stronger password (at least 6 characters).',
        'too-many-requests' => 'Too many attempts. Please wait and try again.',
        _ => 'Authentication failed. Please try again.',
      };
      return false;
    } catch (_) {
      errorMessage.value =
          'Authentication is unavailable. Check Firebase setup and try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _service.logout();
      Get.offAllNamed(AppRoutes.login);
    } catch (_) {
      errorMessage.value = 'Could not sign out. Please try again.';
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
