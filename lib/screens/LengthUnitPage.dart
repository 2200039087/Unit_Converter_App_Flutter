import 'package:flutter/material.dart';

class LengthUnitsPage extends StatefulWidget {
  @override
  _LengthUnitsPageState createState() => _LengthUnitsPageState();
}

class _LengthUnitsPageState extends State<LengthUnitsPage> {
  double convertedValue = 0.0;
  String fromUnit = 'Meters';
  String toUnit = 'Kilometers';
  bool showResult = false;  // Flag to control visibility of result box

  final TextEditingController inputController = TextEditingController();
  final List<String> units = ['Meters', 'Kilometers', 'Feet', 'Inches', 'Miles'];
  final Map<String, double> conversionRates = {
    'Meters': 1.0,
    'Kilometers': 0.001,
    'Feet': 3.28084,
    'Inches': 39.3701,
    'Miles': 0.000621371,
  };

  void convertLength() {
    double inputValue = double.tryParse(inputController.text) ?? 0.0;
    double fromRate = conversionRates[fromUnit] ?? 1.0;
    double toRate = conversionRates[toUnit] ?? 1.0;

    setState(() {
      convertedValue = (inputValue / fromRate) * toRate;
      showResult = true;  // Show result box after conversion
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Converted ${inputValue.toString()} $fromUnit to ${convertedValue.toStringAsFixed(4)} $toUnit 🎉'),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));
  }

  void swapUnits() {
    setState(() {
      String temp = fromUnit;
      fromUnit = toUnit;
      toUnit = temp;
      showResult = false;  // Hide result box when units are swapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Length Converter', style: TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00C9FF).withOpacity(0.8), // Aqua blue
                Color(0xFF8E2DE2), // Bright purple
                Color(0xFF4A00E0), // Deep blue-purple
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Input Card
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.purple.shade50,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Enter a length to convert',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        controller: inputController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Length Value 🌍',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.straighten, color: Colors.deepPurple),
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
                  padding: EdgeInsets.all(16.0),
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
                  padding: EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: convertLength,
                    icon: Icon(Icons.calculate),
                    label: Text(
                      'Convert 🚀',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
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

              // Output Card - Show only if showResult is true
              if (showResult)
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.purple.shade50,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Converted Value:',
                          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
                        ),
                        SizedBox(height: 7.0),
                        Text(
                          '${convertedValue.toStringAsFixed(4)} $toUnit 🎉',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
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
