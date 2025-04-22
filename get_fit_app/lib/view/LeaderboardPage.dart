import 'package:flutter/material.dart';
import '../model/chart_model.dart';
import '../view/chart_veiw.dart';

class LeaderboardPage extends StatelessWidget {
  final Color chartColor;

  const LeaderboardPage({super.key, required this.chartColor});

  List<ChartModel> generateDummyData(int multiplier) {
    List<String> names = ['Alice', 'Bob', 'Carol', 'Dave', 'you'];
    return List.generate(
      names.length,
      (index) => ChartModel(
        x: index,
        y: (index + 1) * multiplier.toDouble(),
        name: names[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 238, 227),
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: const Color.fromARGB(255, 20, 50, 31),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Most workouts (weekly)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            BarChartWidget(data: generateDummyData(2), color: chartColor),

            const SizedBox(height: 30),
            const Text(
              'Most achievements (weekly)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            BarChartWidget(data: generateDummyData(3), color: chartColor),

            const SizedBox(height: 30),
            const Text(
              'Longest workout (daily)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            BarChartWidget(data: generateDummyData(4), color: chartColor),
          ],
        ),
      ),
    );
  }
}
