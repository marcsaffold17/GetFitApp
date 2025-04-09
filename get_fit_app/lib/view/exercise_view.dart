import 'package:flutter/material.dart';
import '../presenter/exercise_presenter.dart';
import '../model/exercies_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../presenter/global_presenter.dart';

class ExercisePage extends StatefulWidget {
  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> implements ExerciseView {
  late ExercisePresenter _presenter;
  List<Exercise> _exercises = [];
  Set<String> _favoriteExercises = {};
  final favoritesRef = FirebaseFirestore.instance.collection('Login-Info').doc(globalUsername).collection('favorites');
  String _errorMessage = "";


  final exerciseTypeText = TextEditingController();
  final muscleTypeText = TextEditingController();

  void _loadFavorites() async {
    final snapshot = await favoritesRef.get();
    setState(() {
      _favoriteExercises = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }


  @override
  void initState() {
    super.initState();
    _presenter = ExercisePresenter(this);
    _loadFavorites();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Exercises"),
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // ),
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
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              onPressed: () {
                getMuscleExercises();
              },
              child: const Text('Search'),
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
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(
                        "Difficulty: ${exercise.difficulty}\n"
                            "Equipment: ${exercise.equipment}",
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.star : Icons.star_border,
                          color: isFavorite ? Colors.amber : Colors.grey,
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
                              'difficulty': exercise.difficulty,
                              'equipment': exercise.equipment,
                              'instructions': exercise.instructions,
                            });
                          } else {
                            await favoritesRef.doc(exercise.name).delete();
                          }
                        },

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
