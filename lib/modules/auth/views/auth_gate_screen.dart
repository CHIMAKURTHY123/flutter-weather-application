// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class AuthGateScreen extends GetView<AuthController> {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) => Obx(() {
    if (controller.user.value == null) {
      return const LoginScreenLink();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute == AppRoutes.authGate) {
        Get.offAllNamed(AppRoutes.dashboard);
      }
    });
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  });
}

class LoginScreenLink extends StatelessWidget {
  const LoginScreenLink({super.key});

  @override
  Widget build(BuildContext context) => const _LoginRedirect();
}

class _LoginRedirect extends StatefulWidget {
  const _LoginRedirect();
  @override
  State<_LoginRedirect> createState() => _LoginRedirectState();
}

class _LoginRedirectState extends State<_LoginRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Get.offAllNamed(AppRoutes.login),
    );
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
