import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _weatherApiKey = '5f091f01b4e8d8bb1108915d39e57971';
  static const String _currencyApiKey = '1sj6ZoH0U5vkt5pPCmHwLuOcft0BTtKS';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_weatherApiKey'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> fetchCurrency(String baseCurrency) async {
    final response = await http.get(Uri.parse(
        'https://api.apilayer.com/latest?access_key=$_currencyApiKey&base=$baseCurrency'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load currency data');
    }
  }
}