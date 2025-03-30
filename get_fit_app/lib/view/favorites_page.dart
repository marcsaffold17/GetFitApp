import 'package:flutter/material.dart';
import 'nav_bar.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Workout> workouts = [
    Workout(name: 'Bench Press', muscles: 'Chest, Triceps, Shoulders', sets: 4),
    Workout(name: 'Squat', muscles: 'Legs, Glutes', sets: 3),
  ];

  void _renameWorkout(Workout workout) {
    TextEditingController controller = TextEditingController(
      text: workout.name,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rename Workout'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter new workout name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  workout.name = controller.text;
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
                    onRename: () => _renameWorkout(workouts[index]),
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

  Workout({required this.name, required this.muscles, required this.sets});
}

class WorkoutItem extends StatelessWidget {
  final Workout workout;
  final VoidCallback onRename;

  const WorkoutItem({super.key, required this.workout, required this.onRename});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workout.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Muscles Worked: ${workout.muscles}'),
            const SizedBox(height: 8),
            Text('Sets: ${workout.sets}'),
          ],
        ),
        IconButton(icon: const Icon(Icons.edit), onPressed: onRename),
      ],
    );
  }
}
