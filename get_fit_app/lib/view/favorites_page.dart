import 'package:flutter/material.dart';
import 'nav_bar.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Workout> workouts = [
    Workout(
      name: 'Bench Press',
      muscles: 'Chest, Triceps, Shoulders',
      sets: 4,
      reps: 10,
    ),
    Workout(name: 'Squat', muscles: 'Legs, Glutes', sets: 3, reps: 12),
  ];

  void _editWorkout(Workout workout) {
    TextEditingController nameController = TextEditingController(
      text: workout.name,
    );
    TextEditingController setsController = TextEditingController(
      text: workout.sets.toString(),
    );
    TextEditingController repsController = TextEditingController(
      text: workout.reps.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Workout Name'),
              ),
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
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  workout.name = nameController.text;
                  workout.sets =
                      int.tryParse(setsController.text) ?? workout.sets;
                  workout.reps =
                      int.tryParse(repsController.text) ?? workout.reps;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Favorites'),
      ),
      drawer: const NavBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: workouts.length,
              separatorBuilder:
                  (context, index) =>
                      const Divider(thickness: 2, color: Colors.black),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: WorkoutItem(
                    workout: workouts[index],
                    onEdit: () => _editWorkout(workouts[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Workout {
  String name;
  String muscles;
  int sets;
  int reps;

  Workout({
    required this.name,
    required this.muscles,
    required this.sets,
    required this.reps,
  });
}

class WorkoutItem extends StatelessWidget {
  final Workout workout;
  final VoidCallback onEdit;

  const WorkoutItem({super.key, required this.workout, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workout.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Muscles Worked: ${workout.muscles}'),
              const SizedBox(height: 8),
              Text('Sets: ${workout.sets}'),
              const SizedBox(height: 8),
              Text('Reps: ${workout.reps}'),
            ],
          ),
        ),
        IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
      ],
    );
  }
}
