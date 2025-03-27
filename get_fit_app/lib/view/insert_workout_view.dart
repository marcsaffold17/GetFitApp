import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../presenter/insert_workout_presenter.dart';
import '../model/insert_workout_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class WorkoutView {
  void onWorkoutAdded();
}

class WorkoutEntryScreen extends StatefulWidget {
  final WorkoutPresenter presenter;

  WorkoutEntryScreen({required this.presenter});

  @override
  _WorkoutEntryScreenState createState() => _WorkoutEntryScreenState();
}

// Initializing various text fields for inserting workout data
class _WorkoutEntryScreenState extends State<WorkoutEntryScreen> implements WorkoutView {
  final _formKey = GlobalKey<FormState>();
  final _dayController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _distanceController = TextEditingController();
  final _timeController = TextEditingController();
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.presenter.view = this;
  }

  @override
  void onWorkoutAdded() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Workout added'),
      duration: Duration(seconds: 2),
    ));

    // Removing user input text fields after workout is added
    _formKey.currentState?.reset();
    _dayController.clear();
    _descriptionController.clear();
    _distanceController.clear();
    _timeController.clear();
    _titleController.clear();
    _typeController.clear();
  }

  // Startup UI, should probably adjust later to fit
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Workout')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _dayController,
                decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              ),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Type of Workout'),
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Time (Minutes)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _distanceController,
                decoration: InputDecoration(labelText: 'Distance (Miles)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Workout Title'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Workout Description'),
              ),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    double? distance = double.tryParse(
                        _distanceController.text) ?? 0.0;
                    int? time = int.tryParse(_timeController.text) ?? 0;
                    final newWorkout = Workout(
                      day: Timestamp.fromDate(DateTime.parse(_dayController.text)),
                      description: _descriptionController.text,
                      distance: distance,
                      time: time,
                      title: _titleController.text,
                      type: _typeController.text,
                  );
                    widget.presenter.addWorkout(newWorkout);
                  }
                },
                child: Text('Add Workout'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        WorkoutHistoryScreen()),
                  );
                },
                child: Text('View Old Workouts'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Screen that shows old workouts submitted to the "Workouts" collection in Firestore
  class WorkoutHistoryScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar
      (title: Text('Workout History')
  ),
  body: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('Workouts')
        .orderBy('Day', descending: true).snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      final workouts = snapshot.data!.docs;
      return ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final workout = workouts[index];
          final data = workout.data() as Map<String, dynamic>;
          return ListTile(
            title: Text(data['Title'] ?? 'No Title'),
            subtitle:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data['Day'] != null && data['Day'] is Timestamp)
                  Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format((data['Day'] as Timestamp).toDate())}',
                  ),
                if (data['Day'] == null || data['Day'] is! Timestamp)
                  Text('Date: No Date'),

                Text('Type: ${data['Type'] ?? 'No Type'}'),
                Text('Time: ${data['Time'] ?? 'No Time'}'),
                Text('Distance: ${data['Distance'] ?? 'No Distance'}'),
                Text('Description: ${data['Description'] ?? 'No Description'}'),
              ],
            ),
          );
        },
      );
     },
    ),
   );
  }
}
