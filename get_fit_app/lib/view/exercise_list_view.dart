import 'dart:io';

import 'package:flutter/material.dart';
import '../presenter/exercise_presenter.dart';
import '../model/exercies_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../presenter/global_presenter.dart';
import 'package:intl/intl.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> implements ExerciseView {
  late ExercisePresenter _presenter;
  List<Exercise> _exercises = [];
  Set<String> _favoriteExercises = {};
  Set<String> _WorkoutPlan = {};
  final favoritesRef = FirebaseFirestore.instance
      .collection('Login-Info')
      .doc(globalUsername)
      .collection('favorites');
  final workoutPlanRef = FirebaseFirestore.instance
      .collection('Login-Info')
      .doc(globalUsername)
      .collection('Workout-Plan');

  String _errorMessage = "";

  final exerciseTypeText = TextEditingController();
  final muscleTypeText = TextEditingController();

  void _loadFavorites() async {
    final snapshot = await favoritesRef.get();
    setState(() {
      _favoriteExercises = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  void _LoadWorkoutPlan() async {
    final snapshot = await workoutPlanRef.get();
    setState(() {
      _WorkoutPlan = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  @override
  void initState() {
    super.initState();
    _presenter = ExercisePresenter(this);
    _loadFavorites();
    _LoadWorkoutPlan();
    _presenter.fetchMuscleExercises(muscleTypeText.text, exerciseTypeText.text);
  }

  void getMuscleExercises() {
    _presenter = ExercisePresenter(this);
    muscleTypeText.text = "muscle";
    if (exerciseTypeText.text == "cardio" ||
        exerciseTypeText.text == "plyometrics" ||
        exerciseTypeText.text == "strength" ||
        exerciseTypeText.text == "stretching") {
      print("works");
      muscleTypeText.text = "type";
    }
    _presenter.fetchMuscleExercises(muscleTypeText.text, exerciseTypeText.text);
  }

  @override
  void showExercises(List<Exercise> exercises) {
    setState(() {
      _exercises = exercises;
      _errorMessage = "";
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
      _exercises = [];
    });
  }

  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  String reps = '';
  String sets = '';
  bool cancelled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              style: TextStyle(
                fontFamily: 'RubikL',
                fontWeight: FontWeight.bold,
              ),
              controller: exerciseTypeText,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Muscle type, Cardio, Stretching',
                hintStyle: TextStyle(
                  fontFamily: 'RubikL',
                  fontWeight: FontWeight.bold,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 20, 50, 31),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(width: 3.0, color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: Container(
                // alignment: Alignment.center,
                width: 250,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 46, 105, 70),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    getMuscleExercises();
                  },
                  child: const Text(
                    'Search',
                    style: TextStyle(
                      color: Color.fromARGB(255, 244, 238, 227),
                      fontFamily: 'MontserratB',
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  _errorMessage.isNotEmpty
                      ? Center(
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = _exercises[index];
                          final isFavorite = _favoriteExercises.contains(
                            exercise.name,
                          );
                          return Card(
                            color: Color.fromARGB(225, 229, 221, 212),
                            margin: EdgeInsets.all(8),
                            child: ListTile(
                              title: Text(
                                exercise.name,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 20, 50, 31),
                                  fontFamily: 'MontserratB',
                                ),
                              ),
                              subtitle: Text(
                                "Difficulty: ${exercise.difficulty}\n"
                                "Equipment: ${exercise.equipment}",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 46, 105, 70),
                                  fontFamily: 'RubikL',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon:
                                          isFavorite
                                              ? Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.star_border,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      151,
                                                      135,
                                                      8,
                                                    ), // Outline
                                                    size: 32,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      242,
                                                      201,
                                                      76,
                                                    ),
                                                    size: 24,
                                                  ),
                                                ],
                                              )
                                              : Icon(
                                                Icons.star_border,
                                                color: Colors.grey,
                                                size: 32,
                                              ),
                                      onPressed: () async {
                                        setState(() {
                                          exercise.isFavorite = !isFavorite;
                                          if (exercise.isFavorite) {
                                            _favoriteExercises.add(
                                              exercise.name,
                                            );
                                          } else {
                                            _favoriteExercises.remove(
                                              exercise.name,
                                            );
                                          }
                                        });
                                        if (exercise.isFavorite) {
                                          await favoritesRef
                                              .doc(exercise.name)
                                              .set({
                                                'name': exercise.name,
                                                'type': exercise.type,
                                                'muscle': exercise.muscle,
                                                'difficulty':
                                                    exercise.difficulty,
                                                'equipment': exercise.equipment,
                                                'instructions':
                                                    exercise.instructions,
                                              });
                                        } else {
                                          await favoritesRef
                                              .doc(exercise.name)
                                              .delete();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add_outlined),
                                      color: Color.fromARGB(255, 81, 163, 108),
                                      onPressed: () async {
                                        final DateTime? pickedDate =
                                            await showDatePicker(
                                              context: context,
                                              builder: DateSelectorColor,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                            );
                                        cancelled = pickedDate == null;
                                        if (!cancelled) {
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Edit Workout',
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    TextField(
                                                      style: TextStyle(
                                                        fontFamily: 'RubikL',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      controller:
                                                          setsController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                            labelText: 'Sets',
                                                          ),
                                                    ),
                                                    TextField(
                                                      style: TextStyle(
                                                        fontFamily: 'RubikL',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      controller:
                                                          repsController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          const InputDecoration(
                                                            labelText: 'Reps',
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      sets =
                                                          setsController.text;
                                                      reps =
                                                          repsController.text;
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    child: Text('Proceed'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                        if (pickedDate != null) {
                                          String formattedDate = DateFormat(
                                            'MM-dd-yyyy',
                                          ).format(pickedDate);
                                          // print(formattedDate);
                                          //   await workoutPlanRef.doc(exercise.name).set({
                                          //     'date': formattedDate,
                                          // });
                                          await workoutPlanRef
                                              .doc(formattedDate)
                                              .set({'date': formattedDate});
                                          await workoutPlanRef
                                              .doc(formattedDate)
                                              .collection("Workout")
                                              .doc(exercise.name)
                                              .set({
                                                'name': exercise.name,
                                                'difficulty':
                                                    exercise.difficulty,
                                                'equipment': exercise.equipment,
                                                'instructions':
                                                    exercise.instructions,
                                                'date': formattedDate,
                                                'reps': reps,
                                                'sets': sets,
                                              });
                                        }
                                        ;
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              onTap: () => _showDetails(exercise),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 244, 238, 227),
          title: Text(
            exercise.name,
            style: TextStyle(
              color: Color.fromARGB(255, 20, 50, 31),
              fontFamily: 'MontserratB',
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  exercise.instructions,
                  style: TextStyle(
                    color: Color.fromARGB(255, 46, 105, 70),
                    fontFamily: 'RubikL',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              width: 100,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 229, 221, 212),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // side: BorderSide(
                    //   color: Color.fromARGB(255, 0, 0, 0),
                    //   width: 1,
                    // ),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Color.fromARGB(255, 202, 59, 59),
                    fontFamily: 'MonsterratB',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget DateSelectorColor(context, child) {
  return Theme(
    data: Theme.of(context).copyWith(
      useMaterial3: true,
      datePickerTheme: DatePickerThemeData(
        weekdayStyle: TextStyle(
          fontFamily: 'MontserratB',
          fontSize: 14,
          // color: Color.fromARGB(255, 255, 0, 174),
        ),
        dayStyle: TextStyle(
          fontFamily: 'RubikL',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          // color: Color(0xFF1E321F),
        ),
        yearStyle: TextStyle(
          fontFamily: 'RubikL',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          // color: Color(0xFF1E321F),
        ),
        dividerColor: Color.fromARGB(255, 20, 50, 31),
      ),
      colorScheme: ColorScheme.dark(
        primary: Color.fromARGB(255, 46, 105, 70),
        onPrimary: Color.fromARGB(255, 229, 221, 212),
        onSurface: Color.fromARGB(255, 30, 50, 31),
        surface: const Color.fromARGB(255, 244, 238, 227),
      ),
    ),
    child: child!,
  );
}
