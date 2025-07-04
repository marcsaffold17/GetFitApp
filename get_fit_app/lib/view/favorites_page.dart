import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../model/exercies_model.dart';
import '../presenter/global_presenter.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Set<String> _WorkoutPlan = {};
  String reps = '';
  String sets = '';
  TextEditingController setsController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController disController = TextEditingController();

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

  bool cancelled = false;

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
                  fontFamily: 'MontserratB',
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
                  cardioType: data['CardioType'],
                  isFavorite: true,
                );
              }).toList();

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: exercises.length,
            separatorBuilder: (context, index) => const SizedBox(height: 25),
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
        contentPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          exercise.name,
          style: TextStyle(
            fontFamily: 'MontserratB',
            color: Color.fromARGB(255, 20, 50, 31),
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
                    style: TextStyle(
                      color: Color.fromARGB(255, 46, 105, 70),
                      fontFamily: 'RubikL',
                      fontWeight: FontWeight.bold,
                    ),
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
                    style: TextStyle(
                      color: Color.fromARGB(255, 46, 105, 70),
                      fontFamily: 'RubikL',
                      fontWeight: FontWeight.bold,
                    ),
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
                Icons.add_outlined,
                color: Color.fromARGB(255, 81, 163, 108),
              ),
              onPressed: () => _addToWorkoutPlan(exercise),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Color.fromARGB(200, 202, 59, 59)),
              onPressed: () async {
                await favoritesRef.doc(exercise.name).delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${exercise.name} removed from favorites'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addToWorkoutPlan(Exercise exercise) async {
    final DateTime? pickedDate = await showDatePicker(
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
            backgroundColor: Color.fromARGB(255, 244, 238, 227),
            title: const Text(
              'Edit Workout',
              style: TextStyle(
                color: Color.fromARGB(255, 20, 50, 31),
                fontFamily: 'MontserratB',
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  exercise.cardioType == 'true'
                      ? [
                        SmallTextField(
                          textController: timeController,
                          lText: 'Time (mins)',
                        ),
                        SmallTextField(
                          textController: disController,
                          lText: 'Distance (Miles)',
                        ),
                      ]
                      : [
                        SmallTextField(
                          textController: setsController,
                          lText: 'Sets',
                        ),
                        SmallTextField(
                          textController: repsController,
                          lText: 'Reps',
                        ),
                      ],
            ),
            actions: [
              Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 229, 221, 212),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 229, 221, 212),
                  ),
                  onPressed: () {
                    sets = setsController.text;
                    reps = repsController.text;
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Proceed',
                    style: TextStyle(
                      color: Color.fromARGB(255, 46, 105, 70),
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

    setsController.clear();
    repsController.clear();

    if (pickedDate != null) {
      String formattedDate = DateFormat('MM-dd-yyyy').format(pickedDate);

      await workoutPlanRef.doc(formattedDate).set({'date': formattedDate});
      if (exercise.cardioType == 'true') {
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
              'Time': timeController.text,
              'Distance': disController.text,
            });
      } else {
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
      }

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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(color: Color.fromARGB(255, 20, 50, 31), thickness: 2),
              Flexible(
                child: SingleChildScrollView(
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
              ),
            ],
          ),
          actions: [
            Container(
              width: 100,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 229, 221, 212),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
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

class SmallTextField extends StatelessWidget {
  const SmallTextField({
    super.key,
    required this.textController,
    required this.lText,
  });

  final TextEditingController textController;
  final String lText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontFamily: 'RubikL', fontWeight: FontWeight.bold),
      controller: textController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 46, 105, 70),
            width: 2,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 46, 105, 70),
            width: 1,
          ), // focused underline color
        ),

        labelText: lText,
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 46, 105, 70),
          fontFamily: 'RubikL',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
