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
  String _selectedType = 'Achievements';

  final List<String> _chartTypeOptions = ['Line', 'Bar'];
  final List<String> _colorOptions = ['Blue', 'Red', 'Green', 'Purple'];
  final List<String> _mainGraphOptions = ['Achievements', 'Reps per week'];

  final Map<String, String> colorHexMap = {
    'Blue': 'FF2196F3',
    'Red': 'FFF44336',
    'Green': 'FF4CAF50',
    'Purple': 'FF9C27B0',
  };

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
      _selectedType = prefs.getString('selectedType') ?? 'Achievements';
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedChart', _selectedChart);
    await prefs.setString('selectedColor', _selectedColor);
    await prefs.setString(
      'chartColor',
      colorHexMap[_selectedColor] ?? 'FF2196F3',
    );
    await prefs.setString('selectedType', _selectedType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      drawer: const NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Chart Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildDropdown(
              label: 'Chart Type',
              value: _selectedChart,
              options: _chartTypeOptions,
              onChanged: (val) => setState(() => _selectedChart = val),
            ),
            const SizedBox(height: 16),

            _buildDropdown(
              label: 'Chart Color',
              value: _selectedColor,
              options: _colorOptions,
              onChanged: (val) => setState(() => _selectedColor = val),
            ),
            const SizedBox(height: 16),

            _buildDropdown(
              label: 'Main Graph Type',
              value: _selectedType,
              options: _mainGraphOptions,
              onChanged: (val) => setState(() => _selectedType = val),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                await _savePreferences();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Preferences saved")),
                );
              },
              child: const Text('Save Preferences'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> options,
    required void Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        DropdownButton<String>(
          isExpanded: true,
          value: value,
          onChanged: (String? newValue) {
            if (newValue != null) onChanged(newValue);
          },
          items:
              options.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
        ),
      ],
    );
  }
}
