import '../models/weather_model.dart';
import '../providers/weather_provider.dart';

class WeatherRepository {
  WeatherRepository(this._provider);
  final WeatherProvider _provider;

  Future<WeatherModel> getWeather(String city, String apiKey) async {
    final json = await _provider.getWeather(city, apiKey);
    try {
      return WeatherModel.fromJson(json);
    } on FormatException catch (error) {
      throw WeatherApiException(
        'The weather service returned invalid data: ${error.message}',
      );
    } on TypeError {
      throw const WeatherApiException(
        'The weather service returned invalid data.',
      );
    } on RangeError {
      throw const WeatherApiException(
        'The weather service returned invalid data.',
      );
    }
  }
}
