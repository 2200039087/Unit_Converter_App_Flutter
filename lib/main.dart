import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';
import 'screens/LengthUnitPage.dart'; // Ensure these pages are implemented
import 'screens/WeightUnitsPage.dart';
import 'screens/ConverterScreen.dart'; // Ensure this points to your ConverterScreen
import 'screens/SettingsScreen.dart';
import 'screens/SpeedUnitsPages.dart'; // Your settings page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      routes: {
        '/units/length': (context) => LengthUnitsPage(),
        '/units/speed': (context) => SpeedUnitsPage(),
        '/units/weight': (context) => WeightUnitsPage(),
        '/converter': (context) => ConverterScreen(), // Pointing to ConverterScreen
        '/settings': (context) => SettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
