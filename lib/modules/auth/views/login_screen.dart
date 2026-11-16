// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/auth_page_shell.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _controller = Get.find<AuthController>();
  bool _showPassword = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final success = await _controller.login(_email.text, _password.text);
    if (success) {
      Get.snackbar('Signed in', 'Welcome back to SkyCast.');
      Get.offAllNamed(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) => AuthPageShell(
    appBarTitle: 'Sign in',
    heading: 'Welcome back',
    description: 'Sign in to continue to your weather dashboard.',
    icon: Icons.cloud_outlined,
    children: [
      TextField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.email],
        decoration: const InputDecoration(
          labelText: 'Email',
          prefixIcon: Icon(Icons.email_outlined),
        ),
      ),
      const SizedBox(height: 14),
      TextField(
        controller: _password,
        obscureText: !_showPassword,
        textInputAction: TextInputAction.done,
        autofillHints: const [AutofillHints.password],
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: 'Password',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            tooltip: _showPassword ? 'Hide password' : 'Show password',
            onPressed: () => setState(() => _showPassword = !_showPassword),
            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
          ),
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
                  child: Text('Sign in'),
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
        onPressed: () => Get.toNamed(AppRoutes.register),
        child: const Text('New here? Create an account'),
      ),
    ],
  );
}
