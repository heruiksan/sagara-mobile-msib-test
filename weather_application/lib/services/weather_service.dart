import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey = '2706852e41cc4180494a1217ada452cc'; // Ganti dengan API Key Anda
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> getCurrentWeather(String city) async {
    final response = await http.get(Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey&units=metric'));
    final forecastResponse = await http.get(Uri.parse('$baseUrl/forecast?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200 && forecastResponse.statusCode == 200) {
      final data = jsonDecode(response.body);
      final forecastData = jsonDecode(forecastResponse.body);
      data['forecast'] = forecastData; 
      return Weather.fromJson(data);
    } else {
      throw Exception('Failed to load weather');
    }
  }
}

