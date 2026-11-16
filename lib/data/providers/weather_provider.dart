import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';

class WeatherProvider {
  WeatherProvider(Dio dio)
    : _dio = dio
        ..options = BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        );

  final Dio _dio;

  Future<Map<String, dynamic>> getWeather(String city, String apiKey) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.currentWeatherEndpoint,
        queryParameters: {'q': city, 'appid': apiKey, 'units': 'metric'},
      );
      final data = response.data;
      if (data == null) {
        throw const WeatherApiException(
          'The weather service returned no data.',
        );
      }
      return data;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 404) {
        throw const WeatherApiException(
          'City not found. Check the spelling and try again.',
        );
      }
      if (status == 401) {
        throw const WeatherApiException(
          'The OpenWeather API key was rejected. Check your .env configuration.',
        );
      }
      if (status == 429) {
        throw const WeatherApiException(
          'Weather requests are temporarily rate limited. Try again shortly.',
        );
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        throw const WeatherApiException(
          'The request timed out. Please try again.',
        );
      }
      if (error.type == DioExceptionType.connectionError) {
        throw const WeatherApiException(
          'Could not connect. Check your internet connection.',
        );
      }
      throw const WeatherApiException(
        'Could not retrieve weather. Please try again.',
      );
    }
  }
}

class WeatherApiException implements Exception {
  const WeatherApiException(this.message);
  final String message;
  @override
  String toString() => message;
}
