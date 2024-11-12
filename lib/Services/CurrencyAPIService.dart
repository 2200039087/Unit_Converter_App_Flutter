import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyAPIService {
  static const String apiKey = '92c30d4d98e5757c8008f2e2';
  static const String _baseUrl = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/USD';

  static Future<Map<String, dynamic>> getCurrencies() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['conversion_rates'];
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  static Future<double> getConversionRate(String base, String target) async {
    final response = await http.get(Uri.parse('https://v6.exchangerate-api.com/v6/$apiKey/latest/$base'));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['conversion_rates'][target];
    } else {
      throw Exception('Failed to load conversion rate');
    }
  }
}
