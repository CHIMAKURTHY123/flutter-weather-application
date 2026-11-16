// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({
    required this.appBarTitle,
    required this.heading,
    required this.description,
    required this.icon,
    required this.children,
    super.key,
  });

  final String appBarTitle;
  final String heading;
  final String description;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(appBarTitle)),
    body: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE5F1FF), Color(0xFFF7FAFE)],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 2,
                shadowColor: const Color(0xFF1A4C7A).withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: const Color(0xFFE7F2FF),
                        child: Icon(
                          icon,
                          size: 34,
                          color: const Color(0xFF2674CE),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        heading,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF20344D),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF718198)),
                      ),
                      const SizedBox(height: 24),
                      ...children,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
