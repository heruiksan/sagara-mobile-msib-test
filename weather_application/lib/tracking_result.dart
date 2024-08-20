import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'services/weather_service.dart';
import 'models/weather_model.dart';

class TrackingResultScreen extends StatefulWidget {
  final String city;

  TrackingResultScreen({required this.city});

  @override
  _TrackingResultScreenState createState() => _TrackingResultScreenState();
}

class _TrackingResultScreenState extends State<TrackingResultScreen> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherService.getCurrentWeather(widget.city);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load weather for ${widget.city}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format current date and time
    final DateFormat formatter = DateFormat('HH:mm - dd MMMM yyyy');
    final String formattedDate = formatter.format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Tracking Result - ${widget.city}'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _weather != null
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Timestamp and current weather
                        Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.blueAccent.withOpacity(0.2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.city} - Weather Forecast',
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              if (_weather!.countryCode.isNotEmpty)
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Image.network(
                                    'https://flagsapi.com/${_weather!.countryCode}/shiny/64.png',
                                    width: 64,
                                    height: 64,
                                    errorBuilder: (context, error, stackTrace) => Text('Flag not available'),
                                  ),
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Current Weather Forecast',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '($formattedDate)',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'Weather: ${_weather!.description}',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.thermostat, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'Temperature: ${_weather!.temperature}°C',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.opacity, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'Humidity: ${_weather!.humidity}%',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.air, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'Wind Speed: ${_weather!.windSpeed} m/s',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              // Separator line
                              Divider(
                                color: Colors.black,
                                height: 1,
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'All Weather Forecast',
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                                  ),
                                ],
                              ),
                        // Forecast for next days
                        ..._weather!.forecast.map((forecast) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.location_city, size: 20),
                                            SizedBox(width: 8),
                                            Text(
                                              'City: ${widget.city} at ${forecast.date}',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.cloud, size: 20),
                                            SizedBox(width: 8),
                                            Text(
                                              'Weather: ${forecast.description}',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.thermostat, size: 20),
                                            SizedBox(width: 8),
                                            Text(
                                              'Temperature: ${forecast.temperature}°C',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.opacity, size: 20),
                                            SizedBox(width: 8),
                                            Text(
                                              'Humidity: ${forecast.humidity}%',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(Icons.air, size: 20),
                                            SizedBox(width: 8),
                                            Text(
                                              'Wind Speed: ${forecast.windSpeed} m/s',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  )
                : Text('No data available'),
      ),
    );
  }
}
