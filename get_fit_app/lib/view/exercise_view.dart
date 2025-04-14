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
  final favoritesRef = FirebaseFirestore.instance.collection('Login-Info').doc(globalUsername).collection('favorites');
  final workoutPlanRef = FirebaseFirestore.instance.collection('Login-Info').doc(globalUsername).collection('Workout-Plan');

  String _errorMessage = "";


  final exerciseTypeText = TextEditingController();
  final muscleTypeText = TextEditingController();

  void _loadFavorites() async {
    final snapshot = await favoritesRef.get();
    setState(() {
      _favoriteExercises = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  void _LoadWorkoutPlan() async{
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

//   Future<void> _selectDate() async {
//   final DateTime? pickedDate = await showDatePicker(
//     context: context, 
//     initialDate: DateTime.now(),
//     firstDate: DateTime(2000), 
//     lastDate: DateTime(2100),
//   );

//   if (pickedDate != null) {
//     String formattedDate = DateFormat('MM/dd/yy').format(pickedDate);
//     print(formattedDate);
//     await workoutPlanRef.doc(exercise.name).set({
//       'date': formattedDate,
//   });
// }

TextEditingController setsController = TextEditingController();
TextEditingController repsController = TextEditingController();
String reps = '';
String sets = '';


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
              controller: exerciseTypeText,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Muscle type, Cardio, Stretching',
              ),
            ),
            SizedBox(height: 15,),
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
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              onPressed: () {
                getMuscleExercises();
              },
              child: const Text('Search', style: TextStyle(color: Color.fromARGB(255, 244, 238, 227), fontSize: 15),textAlign: TextAlign.center,),
            ),
            ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _errorMessage.isNotEmpty
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
                  final isFavorite = _favoriteExercises.contains(exercise.name);
                  return Card(
                    color: Color.fromARGB(225, 229, 221, 212),
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        exercise.name,
                        style: TextStyle(color: Color.fromARGB(255 , 20, 50, 31)),
                        ),
                      subtitle: Text(
                        "Difficulty: ${exercise.difficulty}\n"
                        "Equipment: ${exercise.equipment}",
                        style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite ? const Color.fromARGB(255, 81, 163, 108) : Colors.grey,
                              ),
                              onPressed: () async {
                                setState(() {
                                  exercise.isFavorite = !isFavorite;
                                  if (exercise.isFavorite) {
                                    _favoriteExercises.add(exercise.name);
                                  } else {
                                    _favoriteExercises.remove(exercise.name);
                                  }
                                });
                                if (exercise.isFavorite == true) {
                                  await favoritesRef.doc(exercise.name).set({
                                    'name': exercise.name,
                                    'type': exercise.type,
                                    'muscle': exercise.muscle,
                                    'difficulty': exercise.difficulty,
                                    'equipment': exercise.equipment,
                                    'instructions': exercise.instructions,
                                  });
                                } else {
                                  await favoritesRef.doc(exercise.name).delete();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add_outlined),
                              color: Color.fromARGB(255 ,81, 163, 108),
                              onPressed: () async {
                                  final DateTime? pickedDate = await showDatePicker(
                                    context: context, 
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000), 
                                    lastDate: DateTime(2100),
                                  );

                                  await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Edit Workout'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: setsController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(labelText: 'Sets'),
                                          ),
                                          TextField(
                                            controller: repsController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(labelText: 'Reps'),
                                          ),
                                        ],
                                        
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            sets = setsController.text;
                                            reps = repsController.text;
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Proceed'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                  if (pickedDate != null) {
                                    String formattedDate = DateFormat('MM-dd-yyyy').format(pickedDate);
                                    // print(formattedDate);
                                  //   await workoutPlanRef.doc(exercise.name).set({
                                  //     'date': formattedDate,
                                  // });
                                  await workoutPlanRef.doc(formattedDate).set({
                                    'date': formattedDate,
                                  });
                                  await workoutPlanRef.doc(formattedDate).collection("Workout").doc(exercise.name).set({
                                    'name': exercise.name,
                                    'difficulty': exercise.difficulty,
                                    'equipment': exercise.equipment,
                                    'instructions': exercise.instructions,
                                    'date': formattedDate,
                                    'reps': reps,
                                    'sets': sets
                                  });
                              };
                              
                              }
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
          title: Text(exercise.name),
          content: Text(exercise.instructions),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }
}

