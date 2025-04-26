import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/chart_model.dart';
import '../view/chart_veiw.dart';

class LeaderboardPage extends StatefulWidget {
  final Color chartColor;

  const LeaderboardPage({super.key, required this.chartColor});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<ChartModel> _chartData = [];
  bool _isLoading = true; // <-- Add loading state
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    try {
      List<ChartModel> chartData = await fetchLeaderboardData();
      setState(() {
        _chartData = chartData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: $e';
      });
    }
  }

  Future<List<ChartModel>> fetchLeaderboardData() async {
    var snapshot =
        await FirebaseFirestore.instance
            .collection(
              'leaderboard',
            ) // Make sure to use the correct Firestore collection
            .get();

    return snapshot.docs.map((doc) {
      return ChartModel(
        x: doc['x'],
        y: (doc['y'] ?? 0).toDouble(), // Ensure 'y' is a double
        name: doc['name'] ?? '',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 238, 227),
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: const Color.fromARGB(255, 20, 50, 31),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Most workouts (weekly)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BarChartWidget(data: _chartData, color: widget.chartColor),
                    const SizedBox(height: 30),
                    const Text(
                      'Most achievements (weekly)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BarChartWidget(data: _chartData, color: widget.chartColor),
                    const SizedBox(height: 30),
                    const Text(
                      'Longest workout (daily)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BarChartWidget(data: _chartData, color: widget.chartColor),
                  ],
                ),
              ),
    );
  }
}
