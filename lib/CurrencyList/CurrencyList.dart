import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyAPIService {
  static const String _apiKey = '92c30d4d98e5757c8008f2e2';
  static const String _baseUrl = 'https://v6.exchangerate-api.com/v6/$_apiKey';

  static Future<Map<String, dynamic>> getCurrencies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/latest/USD'),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // Assuming 'conversion_rates' contains the currency data
      return jsonResponse['conversion_rates'];
    } else {
      throw Exception('Failed to load currencies');
    }
  }

  static Future<double> getConversionRate(String base, String target) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/latest/$base'),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['conversion_rates'][target] ?? 0.0;
    } else {
      throw Exception('Failed to load conversion rate');
    }
  }
}
