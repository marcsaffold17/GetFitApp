import 'package:flutter/material.dart';
import '../model/chart_model.dart';
import '../view/chart_veiw.dart'; // Assuming BarChartWidget is in chart_view.dart

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  // Dummy data for demonstration
  List<ChartModel> generateDummyData(int multiplier) {
    return List.generate(
      5,
      (index) => ChartModel(x: index, y: (index + 1) * multiplier.toDouble()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Top Performers - Category A',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            BarChartWidget(data: generateDummyData(2)),

            const SizedBox(height: 30),
            const Text(
              'Top Performers - Category B',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            BarChartWidget(data: generateDummyData(3)),

            const SizedBox(height: 30),
            const Text(
              'Top Performers - Category C',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            BarChartWidget(data: generateDummyData(4)),
          ],
        ),
      ),
    );
  }
}
