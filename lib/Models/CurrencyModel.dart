class CurrencyModel {
  final String name;
  final String code;
  final String symbol;

  CurrencyModel({required this.name, required this.code, required this.symbol});

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      name: json['name'] ?? '',   // Defaults to empty string if 'name' is missing
      code: json['code'] ?? '',   // Defaults to empty string if 'code' is missing
      symbol: json['symbol'] ?? '', // Defaults to empty string if 'symbol' is missing
    );
  }
}
