import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedChart = 'Line';

  @override
  void initState() {
    super.initState();
    _loadChartPreference();
  }

  Future<void> _loadChartPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedChart = prefs.getString('selectedChart') ?? 'Line';
    });
  }

  Future<void> _saveChartPreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedChart', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
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
              onChanged: (String? newValue) async {
                if (newValue != null) {
                  setState(() {
                    _selectedChart = newValue;
                    _saveChartPreference(newValue);
                  });
                  Navigator.pop(
                    context,
                    newValue,
                  ); // Pass the updated chart type back
                }
              },
              items:
                  ['Line', 'Bar'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
