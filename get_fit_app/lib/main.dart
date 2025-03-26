import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fl Graph',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Line Chart Demo'),
    );
  }
}

class LineChartSample extends StatelessWidget {
  const LineChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: const FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 1),
                FlSpot(1, 1.5),
                FlSpot(2, 1.4),
                FlSpot(3, 3.4),
                FlSpot(4, 2),
                FlSpot(5, 2.2),
                FlSpot(6, 1.8),
              ],
              isCurved: true,
              color: Colors.blue,
              barWidth: 4,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

class BarChartSample extends StatelessWidget {
  const BarChartSample({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [BarChartRodData(toY: 1, color: Colors.blue)],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [BarChartRodData(toY: 1.5, color: Colors.blue)],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [BarChartRodData(toY: 1.4, color: Colors.blue)],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [BarChartRodData(toY: 3.4, color: Colors.blue)],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [BarChartRodData(toY: 2, color: Colors.blue)],
            ),
            BarChartGroupData(
              x: 5,
              barRods: [BarChartRodData(toY: 2.2, color: Colors.blue)],
            ),
            BarChartGroupData(
              x: 6,
              barRods: [BarChartRodData(toY: 1.8, color: Colors.blue)],
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedChart = 'Line';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: _selectedChart,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedChart = newValue!;
                });
              },
              items:
                  <String>['Line', 'Bar'].map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            _selectedChart == 'Line'
                ? const LineChartSample()
                : const BarChartSample(),
          ],
        ),
      ),
    );
  }
}
