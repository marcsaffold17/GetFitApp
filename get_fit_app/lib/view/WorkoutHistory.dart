import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../presenter/global_presenter.dart';
import '../view/insert_workout_view.dart';
import '../presenter/insert_workout_presenter.dart';
import '../model/insert_workout_model.dart';
import '../view/photo_view.dart';

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
    final planSnapshot =
        await FirebaseFirestore.instance
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
    final sortedEntries =
        workoutsByDate.entries.toList()..sort((a, b) => b.key.compareTo(a.key));
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                padding: EdgeInsets.only(bottom: 24),
                children: [
                  ...sortedEntries.map((entry) {
                    final date = entry.key;
                    final workouts = entry.value;
                    return ExpansionTile(
                      title: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 46, 105, 70),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          date,
                          style: TextStyle(
                            fontFamily: 'RubikL',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 244, 238, 227),
                          ),
                        ),
                      ),
                      children:
                          workouts
                              .map(
                                (workout) => _WorkoutTile(
                                  workout: workout,
                                  onDelete: fetchAndGroupWorkouts,
                                ),
                              )
                              .toList(),
                    );
                  }).toList(),
                  SizedBox(height: 20),
                ],
              ),
      bottomNavigationBar: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 24.0),
        padding: EdgeInsets.all(20.0),

        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 46, 105, 70),
            padding: EdgeInsets.symmetric(horizontal: 75.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () async {
            final repository =
                WorkoutRepository(); // Make sure this exists and is imported
            final presenter = WorkoutPresenter(repository);

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => WorkoutEntryScreen(
                      presenter: presenter,
                      onWorkoutUploaded:
                          fetchAndGroupWorkouts, // Pass the refresh function
                    ),
              ),
            );
            fetchAndGroupWorkouts();
          },
          child: Text(
            'Add Workout',
            style: TextStyle(
              fontFamily: 'MontserratB',
              color: Color.fromARGB(255, 244, 238, 227),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkoutTile extends StatefulWidget {
  final Map<String, dynamic> workout;
  final VoidCallback onDelete;

  const _WorkoutTile({required this.workout, required this.onDelete});

  @override
  State<_WorkoutTile> createState() => _WorkoutTileState();
}

class _WorkoutTileState extends State<_WorkoutTile> {
  bool isExpanded = false;

  Future<void> _deleteWorkout() async {
    try {
      await FirebaseFirestore.instance
          .collection('Login-Info')
          .doc(globalUsername)
          .collection('Workout-Plan')
          .doc(widget.workout['date'])
          .delete();
      widget.onDelete();
    } catch (e) {
      print('Error deleting workout: $e');
    }
  }

  void _showEditDialog() {
    // if (widget.workout['Distance'] != null || widget.workout['Time'] != null) {
    final disController = TextEditingController(
      text: widget.workout['Distance']?.toString() ?? '',
    );
    final timeController = TextEditingController(
      text: widget.workout['Time']?.toString() ?? '',
    );
    // return;
    // }
    final setsController = TextEditingController(
      text: widget.workout['sets']?.toString() ?? '',
    );
    final repsController = TextEditingController(
      text: widget.workout['reps']?.toString() ?? '',
    );

    Future<void> UpdateingWorkout(
      TextEditingController fController,
      TextEditingController sController,
      BuildContext context,
      String fType,
      String sType,
    ) async {
      String updatedF = fController.text;
      String updatedS = sController.text;

      await FirebaseFirestore.instance
          .collection('Login-Info')
          .doc(globalUsername)
          .collection('Workout-Plan')
          .doc(widget.workout['date'])
          .collection('Workout')
          .doc(widget.workout['exercise'])
          .update({fType: updatedF, sType: updatedS});

      setState(() {
        widget.workout[fType] = updatedF;
        widget.workout[sType] = updatedS;
      });

      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Color.fromARGB(255, 244, 238, 227),
            title: Text(
              'Edit Sets & Reps',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 20, 50, 31),
              ),
            ),
            content:
                (widget.workout['Distance'] != null ||
                        widget.workout['Time'] != null)
                    ? EditingWorkouts(
                      flabel: 'Distance',
                      slabel: 'Time',
                      fController: disController,
                      sController: timeController,
                    )
                    : EditingWorkouts(
                      flabel: 'Reps',
                      slabel: 'Sets',
                      fController: repsController,
                      sController: setsController,
                    ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: Color.fromARGB(255, 46, 105, 70),
                ),
                onPressed: () async {
                  if (widget.workout['Distance'] != null ||
                      widget.workout['Time'] != null) {
                    await UpdateingWorkout(
                      disController,
                      timeController,
                      context,
                      'Distance',
                      'Time',
                    );
                  } else if (widget.workout['sets'] != null ||
                      widget.workout['reps'] != null) {
                    await UpdateingWorkout(
                      repsController,
                      setsController,
                      context,
                      'reps',
                      'sets',
                    );
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Color.fromARGB(255, 244, 238, 227)),
                ),
              ),
            ],
          ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return ImageScreen(imageUrl: imageUrl);
        },
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromARGB(255, 20, 50, 31),
                        fontFamily: 'MontserratB',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 46, 105, 70),
                    ),
                    onPressed: _showEditDialog,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Color.fromARGB(200, 202, 59, 59),
                    ),
                    onPressed: _deleteWorkout,
                  ),
                  IconButton(
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Color.fromARGB(255, 20, 50, 31),
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
              if (workout['difficulty'] != null &&
                  workout['difficulty'] != 'N/A')
                Text(
                  "Difficulty: ${workout['difficulty']}",
                  style: DescriptionsTextStyle(),
                ),
              if (workout['equipment'] != null && workout['equipment'] != 'N/A')
                Text(
                  "Equipment: ${workout['equipment']}",
                  style: DescriptionsTextStyle(),
                ),
              if (workout['sets'] != null && workout['sets'] != 'N/A')
                Text(
                  "Sets: ${workout['sets']}",
                  style: DescriptionsTextStyle(),
                ),
              if (workout['reps'] != null && workout['reps'] != 'N/A')
                Text(
                  "Reps: ${workout['reps']}",
                  style: DescriptionsTextStyle(),
                ),
              if (workout['Type'] != null && workout['Type'] != 'N/A')
                Text(
                  "Type: ${workout['Type']}",
                  style: DescriptionsTextStyle(),
                ),
              if (workout['Distance'] != null && workout['Distance'] != 'N/A')
                Text(
                  "Distance: ${workout['Distance']} miles",
                  style: DescriptionsTextStyle(),
                ),
              if (workout['Time'] != null && workout['Time'] != 'N/A')
                Text(
                  "Time: ${workout['Time']} mins",
                  style: DescriptionsTextStyle(),
                ),
              if (isExpanded)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (workout['Description'] != null &&
                          workout['Description'] != 'N/A')
                        Text(
                          "Description: ${workout['Description']}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 49, 112, 75),
                          ),
                        ),
                      if (workout['instructions'] != null &&
                          workout['instructions'] != 'N/A')
                        Text(
                          "Instructions: ${workout['instructions']}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 49, 112, 75),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (workout['imageURL'] != null)
                            GestureDetector(
                              onTap:
                                  () =>
                                      _showFullScreenImage(workout['imageURL']),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Image.network(
                                  workout['imageURL'],
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          Icon(Icons.error),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle DescriptionsTextStyle() {
    return TextStyle(
      color: Color.fromARGB(255, 49, 112, 75),
      fontWeight: FontWeight.bold,
      fontFamily: 'RubikL',
    );
  }
}

class EditingWorkouts extends StatelessWidget {
  const EditingWorkouts({
    super.key,
    required this.fController,
    required this.sController,
    required this.flabel,
    required this.slabel,
  });

  final TextEditingController fController;
  final TextEditingController sController;
  final String flabel;
  final String slabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: sController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: slabel,
            labelStyle: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 12),
        TextField(
          controller: fController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: flabel,
            labelStyle: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
