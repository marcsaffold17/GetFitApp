import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../presenter/global_presenter.dart';
import '../view/insert_workout_view.dart';
import '../presenter/insert_workout_presenter.dart';
import '../model/insert_workout_model.dart';
import '../view/photo_view.dart';
import '../view/spashscreen.dart';

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

    // 🟢 Rebuild chartData from grouped workouts
    final chartCollection = FirebaseFirestore.instance.collection('chartData');
    int xCounter = 1;
    final sortedEntries =
    grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    for (final entry in sortedEntries) {
      final date = entry.key;
      final workouts = entry.value;
      final y = workouts
          .map((w) {
        if (w['reps'] != null) {
          return int.tryParse(w['reps'].toString()) ?? 0;
        } else if (w['Time'] != null) {
          return int.tryParse(w['Time'].toString()) ?? 0;
        } else {
          return 0;
        }
      })
          .fold(0, (a, b) => a + b);

      await chartCollection.doc(date).set({
        'x': xCounter++,
        'y': y,
        'name': date,
      });
    }
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
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 16.0,
          top: 11.0,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 46, 105, 70),
            padding: EdgeInsets.symmetric(horizontal: 75.0, vertical: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () async {
            final repository = WorkoutRepository();
            final presenter = WorkoutPresenter(repository);

            await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => WorkoutEntryScreen(
                  presenter: presenter,
                  onWorkoutUploaded: fetchAndGroupWorkouts,
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
  final _typeController = TextEditingController();
  String? _workoutType;
  IconData? _workoutTypeIcon;

  @override
  void initState() {
    super.initState();
    _workoutType = widget.workout['Type'];
    // Initialize the icon based on the workout type
    if (_workoutType != null) {
      final workoutTypes = [
        {'type': 'Run', 'icon': Icons.directions_run},
        // ... rest of your workout types
      ];
      final matchingType = workoutTypes.firstWhere(
            (type) => type['type'] == _workoutType,
        orElse: () => {'icon': Icons.fitness_center},
      );
      _workoutTypeIcon = matchingType['icon'] as IconData;
    }
  }

  Future<void> _deleteWorkout() async {
    try {
      await FirebaseFirestore.instance
          .collection('Login-Info')
          .doc(globalUsername)
          .collection('Workout-Plan')
          .doc(widget.workout['date'])
          .collection('Workout')
          .doc(widget.workout['exercise'])
          .delete();
      widget.onDelete();
    } catch (e) {
      print('Error deleting workout: $e');
    }
  }

  void _showEditDialog() {
    final disController = TextEditingController(
      text: widget.workout['Distance']?.toString() ?? '',
    );
    final timeController = TextEditingController(
      text: widget.workout['Time']?.toString() ?? '',
    );
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

    TextStyle selectedStyle = TextStyle(
      fontFamily: 'rubikL',
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Color.fromARGB(255, 46, 105, 70),
    );

    TextStyle unselectedStyle = TextStyle(
      fontFamily: 'RubikL',
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Color.fromARGB(160, 46, 105, 70),
    );

    void _showWorkoutTypeBottomSheet(
        BuildContext context,
        StateSetter setDialogState,
        ) {
      final List<Map<String, dynamic>> workoutTypes = [
        {'type': 'Run', 'icon': Icons.directions_run},
        {'type': 'Walk', 'icon': Icons.directions_walk},
        {'type': 'Hike', 'icon': Icons.hiking},
        {'type': 'Bike', 'icon': Icons.directions_bike},
        {'type': 'Inline Skate', 'icon': Icons.roller_skating},
        {'type': 'Roller Ski', 'icon': Icons.roller_skating},
        {'type': 'Swim', 'icon': Icons.pool},
        {'type': 'Canoe', 'icon': Icons.kayaking},
        {'type': 'Kayak', 'icon': Icons.kayaking},
        {'type': 'Alpine Ski', 'icon': Icons.downhill_skiing},
        {'type': 'Nordic Ski', 'icon': Icons.downhill_skiing},
        {'type': 'Snowboard', 'icon': Icons.snowboarding},
        {'type': 'Ice Skate', 'icon': Icons.ice_skating},
        {'type': 'Snowshoe', 'icon': Icons.snowshoeing},
        {'type': 'Weight Training', 'icon': Icons.fitness_center},
        {'type': 'Rock Climb', 'icon': Icons.landscape},
        {'type': 'Yoga', 'icon': Icons.self_improvement},
        {'type': 'Crossfit', 'icon': Icons.fitness_center},
        {'type': 'StairMaster', 'icon': Icons.stairs},
        {'type': 'Pickleball', 'icon': Icons.sports_tennis},

        // More activities
      ];

      showModalBottomSheet(
        context: context,
        backgroundColor: Color.fromARGB(255, 244, 238, 227),
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 244, 238, 227),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ListView.separated(
              itemCount: workoutTypes.length,
              separatorBuilder:
                  (context, index) => Divider(
                color: Color.fromARGB(255, 20, 50, 31),
                thickness: 1,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final workout = workoutTypes[index];
                return ListTile(
                  tileColor: Colors.grey[850],
                  leading: Icon(
                    workout['icon'] as IconData,
                    color: Color.fromARGB(255, 20, 50, 31),
                  ),
                  title: Text(
                    workout['type'] as String,
                    style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),
                  ),
                  textColor: Color.fromARGB(255, 20, 50, 31),
                  onTap: () {
                    setDialogState(() {
                      _workoutType = workout['type'] as String;
                      _workoutTypeIcon = workout['icon'] as IconData;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          );
        },
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Color.fromARGB(255, 244, 238, 227),
              title:
              widget.workout['Distance'] != null ||
                  widget.workout['Time'] != null
                  ? Text(
                'Edit Time, Distance, & Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Color.fromARGB(255, 20, 50, 31),
                ),
              )
                  : Text(
                'Edit Sets & Reps',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 20, 50, 31),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                (widget.workout['Distance'] != null ||
                    widget.workout['Time'] != null)
                    ? [
                  EditingWorkouts(
                    flabel: 'Distance (Miles)',
                    slabel: 'Time (Mins)',
                    fController: disController,
                    sController: timeController,
                  ),
                  SizedBox(height: 12),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showWorkoutTypeBottomSheet(
                            context,
                            setDialogState,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 244, 238, 227),
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _workoutTypeIcon,
                                color: Color.fromARGB(255, 20, 50, 31),
                              ),
                              SizedBox(width: 8),
                              Text(
                                _workoutType ?? 'Select workout type',
                                style:
                                _workoutType == null
                                    ? TextStyle(
                                  fontFamily: 'RubikL',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(
                                    160,
                                    46,
                                    105,
                                    70,
                                  ),
                                )
                                    : TextStyle(
                                  fontFamily: 'rubikL',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(
                                    255,
                                    46,
                                    105,
                                    70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // This Positioned widget places the label
                      Positioned(
                        left: 10, // Adjust based on where you want it
                        top: -4,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          color: Color.fromARGB(
                            255,
                            244,
                            238,
                            227,
                          ), // match the container color
                          child: Text(
                            'Workout Type',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'RubikL',
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 46, 105, 70),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
                    : [
                  EditingWorkouts(
                    flabel: 'Reps',
                    slabel: 'Sets',
                    fController: repsController,
                    sController: setsController,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Color.fromARGB(255, 202, 59, 59)),
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
                      await FirebaseFirestore.instance
                          .collection('Login-Info')
                          .doc(globalUsername)
                          .collection('Workout-Plan')
                          .doc(widget.workout['date'])
                          .collection('Workout')
                          .doc(widget.workout['exercise'])
                          .update({
                        'Distance': disController.text,
                        'Time': timeController.text,
                        'Type': _workoutType,
                        if (_workoutType != null) 'Type': _workoutType,
                      });
                    } else if (widget.workout['sets'] != null ||
                        widget.workout['reps'] != null) {
                      await FirebaseFirestore.instance
                          .collection('Login-Info')
                          .doc(globalUsername)
                          .collection('Workout-Plan')
                          .doc(widget.workout['date'])
                          .collection('Workout')
                          .doc(widget.workout['exercise'])
                          .update({
                        'reps': repsController.text,
                        'sets': setsController.text,
                      });
                    }
                    Navigator.of(context).pop();
                    widget.onDelete(); // Refresh the list
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Color.fromARGB(255, 244, 238, 227)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 244, 238, 227),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              DeleteText(
                textAlign: TextAlign.center,
                text: "Delete Workout",
                color: Color.fromARGB(255, 20, 50, 31),
                fontSize: 30,
                fontFamily: 'MontserratB',
              ),
              Divider(color: Color.fromARGB(255, 20, 50, 31), thickness: 2),
              DeleteText(
                textAlign: TextAlign.left,
                text: "Are you sure you want to delete this workout?",
                color: Color.fromARGB(255, 46, 105, 70),
                fontSize: 19,
                fontFamily: 'RubikL',
              ),
              SizedBox(height: 12),
              DeleteText(
                textAlign: TextAlign.left,
                text: "This action cannot be undone.",
                color: Color.fromARGB(255, 202, 59, 59),
                fontSize: 15,
                fontFamily: 'RubikL',
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 229, 221, 212),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // SizedBox(width: 8),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 202, 59, 59),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "Delete",
                style: TextStyle(color: Color.fromARGB(255, 244, 238, 227)),
              ),
              onPressed: () {
                _deleteWorkout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
                    onPressed: _showDeleteDialog,
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

class DeleteText extends StatelessWidget {
  const DeleteText({
    super.key,
    required this.textAlign,
    required this.text,
    required this.color,
    required this.fontSize,
    required this.fontFamily,
  });

  final String text;
  final TextAlign textAlign;
  final Color color;
  final double fontSize;
  final String fontFamily;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RichText(
        textAlign: textAlign,
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 46, 105, 70),
                width: 2.0,
              ),
            ),
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
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 46, 105, 70),
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}