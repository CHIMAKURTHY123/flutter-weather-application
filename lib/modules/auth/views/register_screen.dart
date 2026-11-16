// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/auth_page_shell.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _controller = Get.find<AuthController>();
  bool _showPassword = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final success = await _controller.register(
      _email.text,
      _password.text,
      _confirmPassword.text,
    );
    if (success) {
      Get.snackbar('Account created', 'You are signed in and ready to go.');
      Get.offAllNamed(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) => AuthPageShell(
    appBarTitle: 'Create account',
    heading: 'Join SkyCast',
    description: 'Create an account to keep your weather experience ready.',
    icon: Icons.person_add_alt_1_rounded,
    children: [
      TextField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.newUsername],
        decoration: const InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email_outlined),
        ),
      ),
      const SizedBox(height: 14),
      TextField(
        controller: _password,
        obscureText: !_showPassword,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.newPassword],
        decoration: InputDecoration(
          labelText: 'Password (at least 6 characters)',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            tooltip: _showPassword ? 'Hide password' : 'Show password',
            onPressed: () => setState(() => _showPassword = !_showPassword),
            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
          ),
        ),
      ),
      const SizedBox(height: 14),
      TextField(
        controller: _confirmPassword,
        obscureText: !_showPassword,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: const InputDecoration(
          labelText: 'Confirm password',
          prefixIcon: Icon(Icons.lock_reset_outlined),
        ),
      ),
      const SizedBox(height: 20),
      Obx(
        () => _controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : FilledButton(
                onPressed: _submit,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Create account'),
                ),
              ),
      ),
      Obx(
        () => _controller.errorMessage.value.isEmpty
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Text(
                  _controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFC94136)),
                ),
              ),
      ),
      TextButton(
        onPressed: () => Get.offNamed(AppRoutes.login),
        child: const Text('Already registered? Sign in'),
      ),
    ],
  );
}
