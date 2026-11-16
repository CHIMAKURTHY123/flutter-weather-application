// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';

class FirebaseSetupScreen extends StatelessWidget {
  const FirebaseSetupScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Firebase setup required')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.settings, size: 54, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Firebase is not configured for this platform yet.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Create a Firebase project, enable Email/Password sign-in, and add this app in Firebase Console. Run `flutterfire configure` from the project folder, then initialize Firebase with the generated options. For Android and iOS, include the platform configuration files. Authentication cannot be used until this is complete.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Get.offAllNamed(AppRoutes.dashboard),
                child: const Text('Continue to weather as guest'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
