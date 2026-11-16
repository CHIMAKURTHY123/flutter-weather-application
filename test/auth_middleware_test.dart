import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:weather_application/core/routes/app_routes.dart';
import 'package:weather_application/core/routes/auth_middleware.dart';

void main() {
  test('allows guest weather routes when Firebase is not configured', () {
    Get.reset();

    expect(AuthMiddleware().redirect('/dashboard'), isNull);
  });

  test('redirects unauthenticated users and allows authenticated users', () {
    expect(
      AuthMiddleware(isAuthenticated: () => false).redirect('/dashboard')?.name,
      AppRoutes.login,
    );
    expect(
      AuthMiddleware(isAuthenticated: () => true).redirect('/dashboard'),
      isNull,
    );
  });
}
