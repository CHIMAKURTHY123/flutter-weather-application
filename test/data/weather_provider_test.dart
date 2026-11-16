import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_application/data/providers/weather_provider.dart';

void main() {
  test('maps invalid city and invalid key responses to clear errors', () async {
    await expectLater(
      _providerWithStatus(404).getWeather('Unknown', 'key'),
      throwsA(
        isA<WeatherApiException>().having(
          (error) => error.message,
          'message',
          contains('City not found'),
        ),
      ),
    );
    await expectLater(
      _providerWithStatus(401).getWeather('Hyderabad', 'bad-key'),
      throwsA(
        isA<WeatherApiException>().having(
          (error) => error.message,
          'message',
          contains('API key'),
        ),
      ),
    );
    await expectLater(
      _providerWithStatus(429).getWeather('Chennai', 'key'),
      throwsA(
        isA<WeatherApiException>().having(
          (error) => error.message,
          'message',
          contains('rate limited'),
        ),
      ),
    );
  });

  test('maps connection failures and timeouts to actionable errors', () async {
    await expectLater(
      _providerWithFailure(DioExceptionType.connectionError)
          .getWeather('Mumbai', 'key'),
      throwsA(
        isA<WeatherApiException>().having(
          (error) => error.message,
          'message',
          contains('internet connection'),
        ),
      ),
    );
    await expectLater(
      _providerWithFailure(DioExceptionType.connectionTimeout)
          .getWeather('Bengaluru', 'key'),
      throwsA(
        isA<WeatherApiException>().having(
          (error) => error.message,
          'message',
          contains('timed out'),
        ),
      ),
    );
  });
}

WeatherProvider _providerWithStatus(int status) {
  final dio = Dio();
  dio.httpClientAdapter = _TestAdapter(statusCode: status);
  return WeatherProvider(dio);
}

WeatherProvider _providerWithFailure(DioExceptionType type) {
  final dio = Dio();
  dio.httpClientAdapter = _TestAdapter(failureType: type);
  return WeatherProvider(dio);
}

class _TestAdapter implements HttpClientAdapter {
  _TestAdapter({this.statusCode, this.failureType});
  final int? statusCode;
  final DioExceptionType? failureType;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final type = failureType;
    if (type != null) {
      throw DioException(requestOptions: options, type: type);
    }
    return ResponseBody.fromString(
      '{}',
      statusCode ?? 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
