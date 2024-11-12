import 'package:flutter/material.dart';

class WeightUnitsPage extends StatefulWidget {
  @override
  _WeightUnitsPageState createState() => _WeightUnitsPageState();
}

class _WeightUnitsPageState extends State<WeightUnitsPage> with SingleTickerProviderStateMixin {
  final List<String> units = ['Kilograms', 'Grams', 'Pounds', 'Ounces'];
  String baseWeightUnits = 'Kilograms';
  String targetWeightUnits = 'Grams';
  double inputValue = 0.0;
  double convertedValue = 0.0;

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

  void convertWeight() {
    double weightInKg;

    switch (baseWeightUnits) {
      case 'Grams':
        weightInKg = inputValue / 1000;
        break;
      case 'Pounds':
        weightInKg = inputValue * 0.453592;
        break;
      case 'Ounces':
        weightInKg = inputValue * 0.0283495;
        break;
      default:
        weightInKg = inputValue;
    }

    switch (targetWeightUnits) {
      case 'Grams':
        convertedValue = weightInKg * 1000;
        break;
      case 'Pounds':
        convertedValue = weightInKg / 0.453592;
        break;
      case 'Ounces':
        convertedValue = weightInKg / 0.0283495;
        break;
      default:
        convertedValue = weightInKg;
    }

    setState(() {});
  }

  void swapUnits() {
    String temp = baseWeightUnits;
    baseWeightUnits = targetWeightUnits;
    targetWeightUnits = temp;
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weight Converter',
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
                          'Enter weight to convert',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Weight Value ⚖️',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.scale, color: Colors.deepPurple),
                            filled: true,
                            fillColor: Colors.purple.shade50,
                          ),
                          onChanged: (value) {
                            inputValue = double.tryParse(value) ?? 0.0;
                          },
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
                            value: baseWeightUnits,
                            onChanged: (newValue) => setState(() => baseWeightUnits = newValue!),
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
                            value: targetWeightUnits,
                            onChanged: (newValue) => setState(() => targetWeightUnits = newValue!),
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
                      onPressed: convertWeight,
                      icon: Icon(Icons.calculate, color: Colors.white),
                      label: Text(
                        'Convert ⚖️',
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
                          'Converted Weight:',
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
                            '${convertedValue.toStringAsFixed(2)} $targetWeightUnits 🎉',
                            key: ValueKey<double>(convertedValue),
                            style: TextStyle(
                              fontSize: 22.0,
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
          items: units.map<DropdownMenuItem<String>>((String unit) {
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
