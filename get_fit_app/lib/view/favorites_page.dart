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
      backgroundColor: const Color.fromARGB(255, 244, 238, 227),
      body: StreamBuilder<QuerySnapshot>(
        stream: favoritesRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No favorites right now",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final exercises =
              docs.map((doc) {
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

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: exercises.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _buildExerciseCard(exercises[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 229, 221, 212),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          exercise.name,
          style: TextStyle(
            color: Color.fromARGB(255, 20, 50, 31),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 18,
                    color: Color.fromARGB(255, 46, 105, 70),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Difficulty: ${exercise.difficulty}",
                    style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.build,
                    size: 18,
                    color: Color.fromARGB(255, 46, 105, 70),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "Equipment: ${exercise.equipment}",
                    style: TextStyle(color: Color.fromARGB(255, 46, 105, 70)),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () => _showDetails(exercise),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Color.fromARGB(255, 81, 163, 108),
              ),
              onPressed: () async {
                await favoritesRef.doc(exercise.name).delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${exercise.name} removed from favorites'),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.add_outlined,
                color: Color.fromARGB(255, 81, 163, 108),
              ),
              onPressed: () => _addToWorkoutPlan(exercise),
            ),
          ],
        ),
      ),
    );
  }

  void _addToWorkoutPlan(Exercise exercise) async {
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

      await workoutPlanRef.doc(formattedDate).set({'date': formattedDate});

      await workoutPlanRef
          .doc(formattedDate)
          .collection("Workout")
          .doc(exercise.name)
          .set({
            'name': exercise.name,
            'difficulty': exercise.difficulty,
            'equipment': exercise.equipment,
            'instructions': exercise.instructions,
            'date': formattedDate,
            'reps': reps,
            'sets': sets,
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${exercise.name} added to workout plan for ${pickedDate.month}/${pickedDate.day}/${pickedDate.year}',
          ),
        ),
      );
    }
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
