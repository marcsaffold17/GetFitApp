import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/nav_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedChart = 'Line';
  String _selectedColor = 'Blue';

  final List<String> _chartTypeOptions = ['Line', 'Bar'];
  final List<String> _colorOptions = ['Blue', 'Red', 'Green', 'Purple'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedChart = prefs.getString('selectedChart') ?? 'Line';
      _selectedColor = prefs.getString('selectedColor') ?? 'Blue';
    });
  }

  Future<void> _saveChartPreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedChart', value);
  }

  Future<void> _saveColorPreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedColor', value);

    // Save corresponding hex value
    String colorHex;
    switch (value) {
      case 'Red':
        colorHex = 'FFF44336';
        break;
      case 'Green':
        colorHex = 'FF4CAF50';
        break;
      case 'Purple':
        colorHex = 'FF9C27B0';
        break;
      default: // Blue
        colorHex = 'FF2196F3';
    }
    await prefs.setString('chartColor', colorHex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Chart Type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedChart,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedChart = newValue;
                    _saveChartPreference(newValue);
                  });
                }
              },
              items:
                  _chartTypeOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Chart Color:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedColor,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedColor = newValue;
                    _saveColorPreference(newValue);
                  });
                }
              },
              items:
                  _colorOptions.map((String color) {
                    return DropdownMenuItem<String>(
                      value: color,
                      child: Text(color),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
