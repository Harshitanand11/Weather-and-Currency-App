import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isWeatherTabSelected = true;

  String _weatherResult = '';
  bool _isLoading = false;

  String _currencyResult = '';
  bool _isCurrencyLoading = false;

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final TextEditingController _fromCurrencyController = TextEditingController();
  final TextEditingController _toCurrencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _fromCurrencyController.dispose();
    _toCurrencyController.dispose();
    super.dispose();
  }

  void _getWeather() async {
    setState(() {
      _isLoading = true;
    });

    final city = _cityController.text;
    final country = _countryController.text;
    final url =
        'http://api.openweathermap.org/data/2.5/weather?q=$city,$country&appid=5f091f01b4e8d8bb1108915d39e57971';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final weather = data['weather'][0]['description'];
      final temp = (data['main']['temp'] - 273.15).toStringAsFixed(1);

      setState(() {
        _weatherResult = 'Temperature: $temp°C \nWeather: $weather';
        _isLoading = false;
      });
    } else {
      setState(() {
        _weatherResult = 'Error getting weather data';
        _isLoading = false;
      });
    }
  }

  void _getExchangeRate() async {
    setState(() {
      _isCurrencyLoading = true;
    });

    final fromCurrency = _fromCurrencyController.text;
    final toCurrency = _toCurrencyController.text;
    const String _currencyApiKey = '1sj6ZoH0U5vkt5pPCmHwLuOcft0BTtKS';
    final url ='https://openexchangerates.org/api/latest.json?base=USD&app_id=85c29a811f6d4d2fbf376896ab5504ea';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final rate = data['rates'][toCurrency];
      setState(() {
        _currencyResult = '82.9 $fromCurrency = $rate $toCurrency';
        _isCurrencyLoading = false;
      });
    } else {
      setState(() {
        _currencyResult = 'Error getting exchange rate';
        _isCurrencyLoading = false;
      });
    }
  }

  void _toggleTabSelection() {
    setState(() {
      _isWeatherTabSelected = !_isWeatherTabSelected;
      if (_isWeatherTabSelected) {
        _tabController.animateTo(0);
      } else {
        _tabController.animateTo(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather & Currency'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: _toggleTabSelection,
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Weather'),
              Tab(text: 'Currency'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    'Get Weather',
                    style: TextStyle(fontSize: 22.0),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _countryController,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _getWeather,
                    child: Text('Get Weather'),
                  ),
                  SizedBox(height: 10.0),
                  _isLoading
                      ? CircularProgressIndicator()
                      : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(_weatherResult),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    'Get Exchange Rate',
                    style: TextStyle(fontSize: 22.0),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _fromCurrencyController,
                      decoration: InputDecoration(
                        labelText: 'From Currency',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _toCurrencyController,
                      decoration: InputDecoration(
                        labelText: 'To Currency',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _getExchangeRate,
                    child: Text('Get Exchange Rate'),
                  ),
                  SizedBox(height: 10.0),
                  _isCurrencyLoading
                      ? CircularProgressIndicator()
                      : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(_currencyResult),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
