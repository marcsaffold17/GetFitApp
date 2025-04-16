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
    final planSnapshot = await FirebaseFirestore.instance
        .collection('Login-Info')
        .doc(globalUsername)
        .collection('Workout-Plan')
        .get();
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var planDoc in planSnapshot.docs) {
      final date = planDoc.id;
      final workoutSnapshot =
          await planDoc.reference.collection('Workout').get();

      for (var workoutDoc in workoutSnapshot.docs) {
        final workoutData = workoutDoc.data();
        workoutData['date'] = date;
        workoutData['exercise'] = workoutDoc.id;
        grouped.putIfAbsent(date, () => []).add(workoutData);
      }
    }

    setState(() {
      workoutsByDate = grouped;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
  final sortedEntries = workoutsByDate.entries.toList()
    ..sort((a, b) => b.key.compareTo(a.key));
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: sortedEntries.map((entry) {
                SizedBox(height: 20,);
                final date = entry.key;
                final workouts = entry.value;
                return ExpansionTile(
                  title: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 46, 105, 70),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 244, 238, 227),
                      ),
                    ),
                  ),
                  children: workouts
                      .map((workout) => _WorkoutTile(workout: workout))
                      .toList(),
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
        backgroundColor: Color.fromARGB(255, 244, 238, 227),
        title: Text(
          'Edit Sets & Reps',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 20, 50, 31)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: setsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Sets', 
                labelStyle: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: repsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Reps',
                labelStyle: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              backgroundColor: Color.fromARGB(255, 46, 105, 70),
            ),
            onPressed: () async {
              String updatedSets = setsController.text;
              String updatedReps = repsController.text;

              await FirebaseFirestore.instance
                  .collection('Login-Info')
                  .doc(globalUsername)
                  .collection('Workout-Plan')
                  .doc(widget.workout['date'])
                  .collection('Workout')
                  .doc(widget.workout['exercise'])
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
            child: Text('Save', style: TextStyle(color: Color.fromARGB(255, 244, 238, 227)),),
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
        color: Color.fromARGB(255, 229, 221, 212),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromARGB(255, 20, 50, 31)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Color.fromARGB(255, 20, 50, 31)),
                    onPressed: _showEditDialog,
                  ),
                  IconButton(
                    icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Color.fromARGB(255, 20, 50, 31)
                        ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text("Difficulty: ${workout['difficulty'] ?? 'N/A'}", style: TextStyle(color: Color.fromARGB(255, 49, 112, 75))),
              Text("Equipment: ${workout['equipment'] ?? 'N/A'}", style: TextStyle(color: Color.fromARGB(255, 49, 112, 75))),
              Text("Sets: ${workout['sets'] ?? 'N/A'}", style: TextStyle(color: Color.fromARGB(255, 49, 112, 75))),
              Text("Reps: ${workout['reps'] ?? 'N/A'}", style: TextStyle(color: Color.fromARGB(255, 49, 112, 75))),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Instructions: ${workout['instructions'] ?? 'N/A'}",
                    style: TextStyle(color: Color.fromARGB(255, 49, 112, 75),)
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Settings')),
      // drawer: const NavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(0, 18, 7, 7),
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              onPressed: () {
              },
              child: const Text('Search', style: TextStyle(color: Color.fromARGB(255, 244, 238, 227), fontSize: 15),textAlign: TextAlign.center,),
            ),
          ]
        )
      )
    );
}