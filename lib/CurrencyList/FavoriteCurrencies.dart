import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteCurrencies extends StatefulWidget {
  @override
  _FavoriteCurrenciesState createState() => _FavoriteCurrenciesState();
}

class _FavoriteCurrenciesState extends State<FavoriteCurrencies> {
  List<String> favoriteCurrencies = [];
  TextEditingController currencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteCurrencies = prefs.getStringList('favoriteCurrencies') ?? [];
    });
  }

  Future<void> _addFavorite(String currency) async {
    if (currency.isNotEmpty && !favoriteCurrencies.contains(currency)) {
      setState(() {
        favoriteCurrencies.add(currency);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favoriteCurrencies', favoriteCurrencies);
    }
  }

  Future<void> _removeFavorite(String currency) async {
    setState(() {
      favoriteCurrencies.remove(currency);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoriteCurrencies', favoriteCurrencies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Currencies'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: currencyController,
                    decoration: InputDecoration(
                      hintText: 'Enter currency code',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _addFavorite(currencyController.text.trim());
                    currencyController.clear();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favoriteCurrencies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(favoriteCurrencies[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _removeFavorite(favoriteCurrencies[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
