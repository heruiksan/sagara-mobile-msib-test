class Weather {
  final String description;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String countryCode;
  final List<WeatherForecast> forecast; // Tambahkan properti ini

  Weather({
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.countryCode,
    required this.forecast,
  });

  // Metode fromJson untuk parsing data JSON menjadi objek Weather
  factory Weather.fromJson(Map<String, dynamic> json) {
    // Parsing data forecast jika ada
    var forecastList = <WeatherForecast>[];
    if (json['forecast'] != null) {
      forecastList = (json['forecast']['list'] as List)
          .map((item) => WeatherForecast.fromForecastJson(item))
          .toList();
    }

    return Weather(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'].toInt(),
      windSpeed: json['wind']['speed'].toDouble(),
      countryCode: json['sys']['country'],
      forecast: forecastList,
    );
  }
}

class WeatherForecast {
  final String date;
  final String description;
  final double temperature;
  final int humidity;
  final double windSpeed;
  

  WeatherForecast({
    required this.date,
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
  });

  // Metode fromForecastJson untuk parsing data forecast
  factory WeatherForecast.fromForecastJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: json['dt_txt'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'].toInt(),
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}
