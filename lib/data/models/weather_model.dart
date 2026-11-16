class WeatherModel {
  const WeatherModel({
    required this.cityName,
    required this.countryCode,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    this.visibilityMeters,
  });

  final String cityName;
  final String countryCode;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final int? visibilityMeters;

  String get displayLocation =>
      countryCode.isEmpty ? cityName : '$cityName, $countryCode';
  String get iconUrl =>
      icon.isEmpty ? '' : 'https://openweathermap.org/img/wn/$icon@2x.png';
  double? get visibilityKilometers =>
      visibilityMeters == null ? null : visibilityMeters! / 1000;

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final main = _asMap(json['main'], 'main');
    final wind = _asMap(json['wind'], 'wind');
    final weatherList = json['weather'];
    if (weatherList is! List ||
        weatherList.isEmpty ||
        weatherList.first is! Map) {
      throw const FormatException('weather details are missing');
    }
    final condition = Map<String, dynamic>.from(weatherList.first as Map);
    final name = json['name'];
    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('city name is missing');
    }
    final sys = json['sys'] is Map
        ? Map<String, dynamic>.from(json['sys'] as Map)
        : <String, dynamic>{};
    return WeatherModel(
      cityName: name,
      countryCode: sys['country'] is String ? sys['country'] as String : '',
      temperature: _number(main['temp'], 'main.temp'),
      feelsLike: _number(main['feels_like'], 'main.feels_like'),
      humidity: _number(main['humidity'], 'main.humidity').round(),
      windSpeed: _number(wind['speed'], 'wind.speed'),
      description: condition['description'] is String
          ? condition['description'] as String
          : '',
      icon: condition['icon'] is String ? condition['icon'] as String : '',
      visibilityMeters: json['visibility'] is num
          ? (json['visibility'] as num).round()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': cityName,
    'sys': {'country': countryCode},
    'main': {
      'temp': temperature,
      'feels_like': feelsLike,
      'humidity': humidity,
    },
    'wind': {'speed': windSpeed},
    'weather': [
      {'description': description, 'icon': icon},
    ],
    'visibility': visibilityMeters,
  };

  static Map<String, dynamic> _asMap(Object? value, String field) {
    if (value is Map) return Map<String, dynamic>.from(value);
    throw FormatException('$field is missing or invalid');
  }

  static double _number(Object? value, String field) {
    if (value is num) return value.toDouble();
    throw FormatException('$field is missing or invalid');
  }
}
