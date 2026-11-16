import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_application/main.dart';

void main() {
  testWidgets('guest can open the weather dashboard without Firebase setup', (
    WidgetTester tester,
  ) async {
    dotenv.loadFromString(envString: 'OPENWEATHER_API_KEY=');
    await tester.pumpWidget(const WeatherApp());
    await tester.pumpAndSettle();

    expect(
      find.text('Firebase is not configured for this platform yet.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Continue to weather as guest'));
    await tester.pumpAndSettle();

    expect(
      find.text('Search for a city to see current weather conditions.'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Search cities'));
    await tester.pumpAndSettle();
    expect(find.text('Find a city'), findsOneWidget);
    expect(find.text('Recent searches'), findsOneWidget);
  });
}
