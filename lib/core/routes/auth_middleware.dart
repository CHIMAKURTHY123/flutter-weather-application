import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../modules/auth/controllers/auth_controller.dart';
import 'app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  AuthMiddleware({this.isAuthenticated});

  final bool Function()? isAuthenticated;

  @override
  RouteSettings? redirect(String? route) {
    // Guest weather mode remains available when Firebase is not configured.
    if (isAuthenticated == null && !Get.isRegistered<AuthController>()) {
      return null;
    }

    final signedIn =
        isAuthenticated?.call() ??
        Get.find<AuthController>().user.value != null;
    if (!signedIn) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}
