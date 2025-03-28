import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../presenter/chart_presenter.dart';
import '../model/chart_model.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> implements ChartView {
  String _selectedChart = 'Line';
  List<ChartModel> _chartData = [];
  late ChartPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = ChartPresenter(this);
    _presenter.loadData();
  }

  @override
  void updateChart(List<ChartModel> data) {
    setState(() {
      _chartData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter MVP Chart')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _selectedChart,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedChart = newValue!;
                });
              },
              items:
                  ['Line', 'Bar'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            if (_chartData.isNotEmpty)
              _selectedChart == 'Line'
                  ? LineChartWidget(data: _chartData)
                  : BarChartWidget(data: _chartData),
          ],
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<ChartModel> data;

  const LineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: data.map((e) => FlSpot(e.x.toDouble(), e.y)).toList(),
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

class BarChartWidget extends StatelessWidget {
  final List<ChartModel> data;

  const BarChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups:
              data
                  .map(
                    (e) => BarChartGroupData(
                      x: e.x,
                      barRods: [BarChartRodData(toY: e.y, color: Colors.blue)],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

Widget displayChart(List<ChartModel> chartData, String selectedChart) {
  if (chartData.isEmpty) return const SizedBox.shrink();
  return selectedChart == 'Line'
      ? LineChartWidget(data: chartData)
      : BarChartWidget(data: chartData);
}
