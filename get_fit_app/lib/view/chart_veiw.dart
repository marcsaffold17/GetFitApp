import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chart_model.dart';

class LineChartWidget extends StatefulWidget {
  final List<ChartModel> data;
  final Color color;

  const LineChartWidget({super.key, required this.data, required this.color});

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
                  color: widget.color,
                  barWidth: 4,
                  belowBarData: BarAreaData(show: false),
                  dotData: FlDotData(show: false),
                ),
              ],
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      const epsilon = 0.01;
                      final match = widget.data.firstWhere(
                        (e) => (e.x.toDouble() - value).abs() < epsilon,
                        orElse:
                            () => ChartModel(x: value.toInt(), y: 0, name: ''),
                      );
                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        child: Text(
                          match.name,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 42),
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
  final Color color;

  const BarChartWidget({super.key, required this.data, required this.color});

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
            toY: e.y * _animation.value,
            fromY: 0,
            color: widget.color,
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
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      const epsilon = 0.01;
                      final match = widget.data.firstWhere(
                        (e) => (e.x.toDouble() - value).abs() < epsilon,
                        orElse:
                            () => ChartModel(x: value.toInt(), y: 0, name: ''),
                      );
                      return SideTitleWidget(
                        meta: meta,
                        space: 8,
                        child: Text(
                          match.name,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 30),
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

class GraphScreen extends StatelessWidget {
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout Graph')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection(
                  'chartData',
                ) // Replace with your actual collection name
                .orderBy('x')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Process your data from Firestore
          List<ChartModel> chartData =
              snapshot.data!.docs
                  .map((doc) => ChartModel.fromFirestore(doc))
                  .toList();

          return Column(
            children: [
              LineChartWidget(data: chartData, color: Colors.blue),
              BarChartWidget(data: chartData, color: Colors.green),
            ],
          );
        },
      ),
    );
  }
}
