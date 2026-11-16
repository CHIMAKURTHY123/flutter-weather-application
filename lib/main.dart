import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/bindings/initial_binding.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  var firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (_) {
    // Firebase Console configuration is required; the app has a guest weather mode.
  }

  try {
    await dotenv.load(fileName: '.env', isOptional: true);
  } catch (_) {
    // Weather search displays setup guidance if the local environment file is absent.
  }

  runApp(WeatherApp(firebaseReady: firebaseReady));
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key, this.firebaseReady = false});

  final bool firebaseReady;

  @override
  Widget build(BuildContext context) => GetMaterialApp(
    title: 'Weather Application',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    initialBinding: InitialBinding(firebaseReady: firebaseReady),
    initialRoute: firebaseReady ? AppRoutes.authGate : AppRoutes.firebaseSetup,
    getPages: AppPages.pages,
    defaultTransition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 180),
  );
}
