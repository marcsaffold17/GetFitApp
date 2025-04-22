import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../model/exercies_model.dart';
import '../presenter/global_presenter.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Set<String> _WorkoutPlan = {};
  String reps = '';
  String sets = '';
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();

  final favoritesRef = FirebaseFirestore.instance
      .collection('Login-Info')
      .doc(globalUsername)
      .collection('favorites');
  final workoutPlanRef = FirebaseFirestore.instance
      .collection('Login-Info')
      .doc(globalUsername)
      .collection('Workout-Plan');

  @override
  void initState() {
    super.initState();
    _LoadWorkoutPlan();
  }

  void _LoadWorkoutPlan() async {
    final snapshot = await workoutPlanRef.get();
    setState(() {
      _WorkoutPlan = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      body: StreamBuilder<QuerySnapshot>(
        stream: favoritesRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(
              child: Text(
                "No favorites right now",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final exercises = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Exercise(
              name: data['name'],
              type: data['type'],
              muscle: data['muscle'],
              difficulty: data['difficulty'],
              equipment: data['equipment'],
              instructions: data['instructions'],
              isFavorite: true,
            );
          }).toList();

          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              return _buildExerciseCard(exercises[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
      color: Color.fromARGB(255, 229, 221, 212),
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(exercise.name, style: TextStyle(color: Color.fromARGB(255, 20, 50, 31))),
        subtitle: Text(
          "Difficulty: ${exercise.difficulty}\nEquipment: ${exercise.equipment}",
          style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),
        ),
        onTap: () => _showDetails(exercise),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete, color: Color.fromARGB(255, 81, 163, 108)),
              onPressed: () async {
                await favoritesRef.doc(exercise.name).delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${exercise.name} removed from favorites')),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add_outlined),
              color: Color.fromARGB(255, 81, 163, 108),
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

                setsController.clear();
                repsController.clear();

                if (pickedDate != null) {
                  String formattedDate = DateFormat('MM-dd-yyyy').format(pickedDate);

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

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${exercise.name} added to workout plan for ${pickedDate.day}/${pickedDate.month}/${pickedDate.year}')),
                  );
                }
              },
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
          title: Text(exercise.name, style: TextStyle(color: Color.fromARGB(255, 20, 50, 31))),
          content: Text(exercise.instructions, style: TextStyle(color: Color.fromARGB(255, 46, 105, 70))),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: TextStyle(color: Color.fromARGB(255, 46, 105, 70))),
            ),
          ],
        );
      },
    );
  }
}
