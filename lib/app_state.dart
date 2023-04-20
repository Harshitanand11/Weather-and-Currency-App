import 'package:flutter/material.dart';
import 'api_service.dart';

enum WidgetType { weather, currency }

class AppState with ChangeNotifier {
  WidgetType _widgetType = WidgetType.weather;
  String _selectedCity = 'New York';
  String _selectedCurrency = 'USD';
  Map<String, dynamic>? _weatherData;
  Map<String, dynamic>? _currencyData;
  ApiService _apiService = ApiService();

  WidgetType get widgetType => _widgetType;
  String get selectedCity => _selectedCity;
  String get selectedCurrency => _selectedCurrency;
  Map<String, dynamic>? get weatherData => _weatherData;
  Map<String, dynamic>? get currencyData => _currencyData;

  void setWidgetType(WidgetType type) {
    _widgetType = type;
    notifyListeners();
  }

  void setSelectedCity(String city) {
    _selectedCity = city;
    notifyListeners();
  }

  void setSelectedCurrency(String currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  void setWeatherData(Map<String, dynamic>? data) {
    _weatherData = data;
    notifyListeners();
  }

  void setCurrencyData(Map<String, dynamic>? data) {
    _currencyData = data;
    notifyListeners();
  }

  Future<void> fetchWeather() async {
    final data = await _apiService.fetchWeather(_selectedCity);
    setWeatherData(data);
  }

  Future<void> fetchCurrency() async {
    final data = await _apiService.fetchCurrency(_selectedCurrency);
    setCurrencyData(data);
  }
}
