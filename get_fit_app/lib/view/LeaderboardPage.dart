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
  List<ChartModel> _workoutsData = [];
  List<ChartModel> _repsData = [];
  List<ChartModel> _longestWorkoutsData = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    try {
      List<ChartModel> workoutsData = await fetchData('workouts');
      List<ChartModel> repsData = await fetchData('reps');
      List<ChartModel> longestWorkoutsData = await fetchData('longestWorkouts');

      setState(() {
        _workoutsData = workoutsData;
        _repsData = repsData;
        _longestWorkoutsData = longestWorkoutsData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: $e';
      });
    }
  }

  Future<List<ChartModel>> fetchData(String collectionName) async {
    var snapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();

    return snapshot.docs.map((doc) {
      return ChartModel(
        x: doc['x'],
        y: (doc['y'] ?? 0).toDouble(),
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
                    BarChartWidget(
                      data: _workoutsData,
                      color: widget.chartColor,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Most reps (weekly)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BarChartWidget(data: _repsData, color: widget.chartColor),
                    const SizedBox(height: 30),
                    const Text(
                      'Longest workout (daily)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BarChartWidget(
                      data: _longestWorkoutsData,
                      color: widget.chartColor,
                    ),
                  ],
                ),
              ),
    );
  }
}
