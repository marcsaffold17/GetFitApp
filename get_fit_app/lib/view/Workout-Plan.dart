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
                  title: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(167, 196, 189,1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ),
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

  void _showEditDialog() {
    final setsController =
        TextEditingController(text: widget.workout['sets']?.toString() ?? '');
    final repsController =
        TextEditingController(text: widget.workout['reps']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Edit Sets & Reps',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: setsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Sets',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Reps',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              backgroundColor: Colors.deepPurple,
            ),
            onPressed: () async {
              String updatedSets = setsController.text;
              String updatedReps = repsController.text;

              await FirebaseFirestore.instance
                  .collection('Login-Info')
                  .doc(globalUsername)
                  .collection('Workout-Plan')
                  .doc(widget.workout['name'])
                  .update({
                'sets': updatedSets,
                'reps': updatedReps,
              });

              setState(() {
                widget.workout['sets'] = updatedSets;
                widget.workout['reps'] = updatedReps;
              });

              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workout = widget.workout;

    return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Color(0xFFF9F9F9),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    workout['name'] ?? 'Unnamed',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.black),
                  onPressed: _showEditDialog,
                ),
                IconButton(
                  icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 4),
            Text("Difficulty: ${workout['difficulty'] ?? 'N/A'}"),
            Text("Equipment: ${workout['equipment'] ?? 'N/A'}"),
            Text("Sets: ${workout['sets'] ?? 'N/A'}"),
            Text("Reps: ${workout['reps'] ?? 'N/A'}"),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Instructions: ${workout['instructions'] ?? 'N/A'}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
          ],
        ),
      ),
    ),
  );
  }
}

