import 'package:flutter/material.dart';

class SpeedUnitsPage extends StatefulWidget {
  @override
  _SpeedUnitsPageState createState() => _SpeedUnitsPageState();
}

class _SpeedUnitsPageState extends State<SpeedUnitsPage> with SingleTickerProviderStateMixin {
  final TextEditingController speedController = TextEditingController();
  String fromUnit = 'm/s';
  String toUnit = 'km/h';
  double convertedSpeed = 0.0;

  final List<String> speedUnits = ['m/s', 'km/h', 'mph', 'ft/s'];

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  void convertSpeed() {
    double speed = double.tryParse(speedController.text) ?? 0.0;
    double kmhSpeed;

    switch (fromUnit) {
      case 'm/s':
        kmhSpeed = speed * 3.6;
        break;
      case 'km/h':
        kmhSpeed = speed;
        break;
      case 'mph':
        kmhSpeed = speed * 1.60934;
        break;
      case 'ft/s':
        kmhSpeed = speed * 1.09728;
        break;
      default:
        kmhSpeed = speed;
    }

    switch (toUnit) {
      case 'm/s':
        convertedSpeed = kmhSpeed / 3.6;
        break;
      case 'km/h':
        convertedSpeed = kmhSpeed;
        break;
      case 'mph':
        convertedSpeed = kmhSpeed / 1.60934;
        break;
      case 'ft/s':
        convertedSpeed = kmhSpeed / 1.09728;
        break;
      default:
        convertedSpeed = kmhSpeed;
    }

    setState(() {});
  }

  void swapUnits() {
    setState(() {
      final temp = fromUnit;
      fromUnit = toUnit;
      toUnit = temp;
    });
  }

  @override
  void dispose() {
    speedController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Speed Converter',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00C9FF).withOpacity(0.8),
                Color(0xFF8E2DE2),
                Color(0xFF4A00E0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00C9FF).withOpacity(0.8),
                Color(0xFF8E2DE2),
                Color(0xFF4A00E0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Input Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.purple.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Enter speed to convert',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          controller: speedController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Speed Value 🌍',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.speed, color: Colors.deepPurple),
                            filled: true,
                            fillColor: Colors.purple.shade50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),

                // Unit Selection Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.purple.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            value: fromUnit,
                            onChanged: (newValue) => setState(() => fromUnit = newValue!),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: swapUnits,
                            child: Icon(Icons.swap_horiz, color: Colors.deepPurple, size: 32),
                          ),
                        ),
                        Expanded(
                          child: _buildDropdown(
                            value: toUnit,
                            onChanged: (newValue) => setState(() => toUnit = newValue!),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),

                // Convert Button Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: convertSpeed,
                      icon: Icon(Icons.calculate, color: Colors.white),
                      label: Text(
                        'Convert 🚀',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        textStyle: TextStyle(fontSize: 18),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5.0),

                // Output Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.purple.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Converted Speed:',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        SizedBox(height: 1.0),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Text(
                            '${convertedSpeed.toStringAsFixed(2)} $toUnit 🎉',
                            key: ValueKey<double>(convertedSpeed),
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({required String value, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items: speedUnits.map<DropdownMenuItem<String>>((String unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
        ),
      ),
    );
  }
}
