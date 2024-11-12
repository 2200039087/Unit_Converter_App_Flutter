import 'package:flutter/material.dart';
import '../Services/CurrencyAPIService.dart';

class ConverterScreen extends StatefulWidget {
  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> with SingleTickerProviderStateMixin {
  double convertedAmount = 0.0;
  bool isLoading = false;
  List<String> currencies = [];

  final TextEditingController amountController = TextEditingController();
  String baseCurrency = 'INR';
  String targetCurrency = 'USD';

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
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    setState(() => isLoading = true);
    try {
      final data = await CurrencyAPIService.getCurrencies();
      setState(() {
        currencies = data.keys.toList(); // Extracts currency codes
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading currencies: $e')),
      );
    }
  }

  void convertCurrency() async {
    if (amountController.text.isNotEmpty) {
      double enteredAmount = double.tryParse(amountController.text) ?? 0.0;
      if (enteredAmount > 0) {
        FocusScope.of(context).unfocus();
        setState(() => isLoading = true);

        try {
          double rate = await CurrencyAPIService.getConversionRate(baseCurrency, targetCurrency);
          setState(() {
            convertedAmount = enteredAmount * rate;
          });
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error fetching conversion rate: $error')),
          );
        } finally {
          setState(() => isLoading = false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid amount.')),
        );
      }
    }
  }

  void swapCurrencies() {
    setState(() {
      String temp = baseCurrency;
      baseCurrency = targetCurrency;
      targetCurrency = temp;
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Currency Converter',
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
                          'Enter Amount to Convert',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Amount 💱',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.monetization_on, color: Colors.deepPurple),
                            filled: true,
                            fillColor: Colors.purple.shade50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                // Currency Selection Card
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
                            value: baseCurrency,
                            onChanged: (newValue) => setState(() => baseCurrency = newValue!),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: swapCurrencies,
                            child: Icon(Icons.swap_horiz, color: Colors.deepPurple, size: 32),
                          ),
                        ),
                        Expanded(
                          child: _buildDropdown(
                            value: targetCurrency,
                            onChanged: (newValue) => setState(() => targetCurrency = newValue!),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                // Convert Button Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : convertCurrency,
                      icon: Icon(Icons.transform, color: Colors.white),
                      label: Text(
                        'Convert 💹',
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
                SizedBox(height: 10.0),

                // Output Card
                if (convertedAmount > 0)
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.purple.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Converted Amount:',
                            style: TextStyle(
                              fontSize: 22.0,
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
                              '${amountController.text} $baseCurrency = ${convertedAmount.toStringAsFixed(2)} $targetCurrency 🎉',
                              key: ValueKey<double>(convertedAmount),
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
          items: currencies.map<DropdownMenuItem<String>>((String currency) {
            return DropdownMenuItem<String>(
              value: currency,
              child: Text(currency, style: TextStyle(color: Colors.deepPurple)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
