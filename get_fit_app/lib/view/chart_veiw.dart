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

class LineChartWidget extends StatefulWidget {
  final List<ChartModel> data;

  const LineChartWidget({super.key, required this.data});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<FlSpot> _animatedSpots() {
    final fullSpots =
        widget.data.map((e) => FlSpot(e.x.toDouble(), e.y)).toList();

    final animatedCount =
        (_animation.value * fullSpots.length)
            .clamp(0, fullSpots.length)
            .floor();

    if (animatedCount == 0) return [];

    final shownSpots = fullSpots.sublist(0, animatedCount);

    if (animatedCount < fullSpots.length) {
      final nextSpot = fullSpots[animatedCount];
      final prevSpot = fullSpots[animatedCount - 1];

      final progress = (_animation.value * fullSpots.length) % 1.0;
      final interpolated = FlSpot(
        prevSpot.x + (nextSpot.x - prevSpot.x) * progress,
        prevSpot.y + (nextSpot.y - prevSpot.y) * progress,
      );

      shownSpots.add(interpolated);
    }

    return shownSpots;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: _animatedSpots(),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 4,
                  belowBarData: BarAreaData(show: false),
                  dotData: FlDotData(show: false),
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      final name =
                          index >= 0 && index < widget.data.length
                              ? widget.data[index].name
                              : '';
                      return SideTitleWidget(
                        space: 8,
                        child: Text(name, style: const TextStyle(fontSize: 10)),
                        meta: meta,
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true),
              lineTouchData: LineTouchData(enabled: false),
            ),
          );
        },
      ),
    );
  }
}

class BarChartWidget extends StatefulWidget {
  final List<ChartModel> data;

  const BarChartWidget({super.key, required this.data});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<BarChartGroupData> _buildBarGroups() {
    return widget.data.map((e) {
      return BarChartGroupData(
        x: e.x,
        barRods: [
          BarChartRodData(
            toY: e.y * _animation.value, // Animate bar height only
            fromY: 0, // Always start from bottom
            color: Colors.blue,
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return BarChart(
            BarChartData(
              barGroups: _buildBarGroups(),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      final name =
                          index >= 0 && index < widget.data.length
                              ? widget.data[index].name
                              : '';
                      return SideTitleWidget(
                        space: 8,
                        child: Text(name, style: const TextStyle(fontSize: 10)),
                        meta: meta,
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: true),
              alignment: BarChartAlignment.spaceAround,
              maxY:
                  widget.data.map((e) => e.y).reduce((a, b) => a > b ? a : b) +
                  2,
            ),
          );
        },
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
