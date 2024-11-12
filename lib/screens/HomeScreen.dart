import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Tracks the hovered index for scaling effect
  int hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Unit Converter', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Vibrant and animated background
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color(0xFF00C9FF).withOpacity(0.8), // Aqua blue
                  Color(0xFF8E2DE2), // Bright purple
                  Color(0xFF4A00E0), // Deep blue-purple
                ],
                center: Alignment.center,
                radius: 1.5,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated text at the top
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Choose a Converter',
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      colors: [
                        Colors.white,
                        Colors.amber,
                        Colors.lightBlue,
                        Colors.purpleAccent,
                      ],
                    ),
                  ],
                  isRepeatingAnimation: true,
                ),
                SizedBox(height: 30),
                // Grid with interactive cards
                SizedBox(
                  height: 400,
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final items = [
                        {
                          'lottieAsset': 'assets/lottie/length.json',
                          'title': 'Length Converter',
                          'route': '/units/length',
                        },
                        {
                          'lottieAsset': 'assets/lottie/speed.json',
                          'title': 'Speed Converter',
                          'route': '/units/speed',
                        },
                        {
                          'lottieAsset': 'assets/lottie/weight.json',
                          'title': 'Weight Converter',
                          'route': '/units/weight',
                        },
                        {
                          'lottieAsset': 'assets/lottie/currency.json',
                          'title': 'Currency Converter',
                          'route': '/converter',
                        },
                      ];
                      return _buildConverterCard(
                        context,
                        index: index,
                        lottieAsset: items[index]['lottieAsset']!,
                        title: items[index]['title']!,
                        route: items[index]['route']!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to create a hoverable and interactive converter card
  Widget _buildConverterCard(BuildContext context,
      {required int index, required String lottieAsset, required String title, required String route}) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoveredIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          hoveredIndex = -1;
        });
      },
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: AnimatedScale(
          scale: hoveredIndex == index ? 1.1 : 1.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Card(
            color: Colors.white.withOpacity(0.8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  lottieAsset,
                  width: 100,
                  height: 95,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
