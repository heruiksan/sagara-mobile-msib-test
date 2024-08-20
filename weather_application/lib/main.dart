import 'package:flutter/material.dart';
import 'services/weather_service.dart';
import 'models/weather_model.dart';
import 'tracking_result.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue, 
        ),
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = false;
  List<Map<String, String>> _cities = []; 

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await _weatherService.getCurrentWeather(city);
      setState(() {
        _cities.add({'city': city, 'countryCode': weather.countryCode}); 
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load weather for $city')),
      );
    }
  }

  void _showCityInputDialog() {
    final TextEditingController _cityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter City Name'),
          content: TextField(
            controller: _cityController,
            decoration: InputDecoration(hintText: 'City Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                String city = _cityController.text.trim();
                if (city.isNotEmpty) {
                  try {
                    final weather = await _weatherService.getCurrentWeather(city);
                    setState(() {
                      _cities.add({'city': city, 'countryCode': weather.countryCode}); 
                    });
                    Navigator.of(context).pop(); 
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('City not found or invalid')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('City name cannot be empty')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditCityDialog(int index) {
    final TextEditingController _cityController = TextEditingController();
    _cityController.text = _cities[index]['city']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit City Name'),
          content: TextField(
            controller: _cityController,
            decoration: InputDecoration(hintText: 'City Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Update'),
              onPressed: () async {
                String city = _cityController.text.trim();
                if (city.isNotEmpty) {
                  try {
                    final weather = await _weatherService.getCurrentWeather(city);
                    setState(() {
                      _cities[index] = {'city': city, 'countryCode': weather.countryCode}; 
                    });
                    Navigator.of(context).pop(); 
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('City not found or invalid')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('City name cannot be empty')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteCity(int index) {
    setState(() {
      _cities.removeAt(index); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _cities.isEmpty
                ? Text('No data available')
                : ListView.separated(
                    itemCount: _cities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(
                          'https://flagsapi.com/${_cities[index]['countryCode']}/shiny/64.png',
                          width: 32,
                          height: 32,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.flag),
                        ),
                        title: Text('${_cities[index]['city']} - ${_cities[index]['countryCode']}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackingResultScreen(city: _cities[index]['city']!),
                            ),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditCityDialog(index); 
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteCity(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(), 
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCityInputDialog,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}
