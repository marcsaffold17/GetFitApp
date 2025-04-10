import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../presenter/global_presenter.dart';

class WorkoutHistoryByDate extends StatefulWidget {
  @override
  _WorkoutHistoryByDateState createState() => _WorkoutHistoryByDateState();
}

class _WorkoutHistoryByDateState extends State<WorkoutHistoryByDate> {
  Map<String, List<Map<String, dynamic>>> workoutsByDate = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndGroupWorkouts();
  }

  Future<void> fetchAndGroupWorkouts() async {
    final snapshot = await FirebaseFirestore.instance.collection('Login-Info').doc(globalUsername).collection('Workout-Plan').get();


    final List<Map<String, dynamic>> allWorkouts =
        snapshot.docs.map((doc) => doc.data()).toList();

    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var workout in allWorkouts) {
      final date = workout['date'] ?? 'Unknown Date';
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(workout);
    }

    setState(() {
      workoutsByDate = grouped;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Workout History')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: workoutsByDate.entries.map((entry) {
                final date = entry.key;
                final workouts = entry.value;

                return ExpansionTile(
                  title: Text(date),
                  children: workouts.map((workout) {
                    return _WorkoutTile(workout: workout);
                  }).toList(),
                );
              }).toList(),
            ),
    );
  }
}

class _WorkoutTile extends StatefulWidget {
  final Map<String, dynamic> workout;

  const _WorkoutTile({required this.workout});

  @override
  State<_WorkoutTile> createState() => _WorkoutTileState();
}

class _WorkoutTileState extends State<_WorkoutTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final workout = widget.workout;

    return Column(
      children: [
        ListTile(
          title: Text(workout['name'] ?? 'Unnamed'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Difficulty: ${workout['difficulty'] ?? 'N/A'}"),
              Text("Equipment: ${workout['equipment'] ?? 'N/A'}"),
            ],
          ),
          trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Instructions: ${workout['instructions'] ?? 'N/A'}",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ),
        Divider(height: 1),
      ],
    );
  }
}
