import 'package:flutter/material.dart';
import '../presenter/insert_workout_presenter.dart';
import '../model/insert_workout_model.dart';


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
    // Handle successful workout addition
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Workout added successfully!'),
    ));
    // Clear the form or navigate away
    _formKey.currentState?.reset();
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
                decoration: InputDecoration(labelText: 'Day'),
              ),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Type'),
              ),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Time'),
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newWorkout = Workout(
                      day: _dayController.text,
                      description: _descriptionController.text,
                      time: _timeController.text,
                      title: _titleController.text,
                      type: _typeController.text,
                    );
                    widget.presenter.addWorkout(newWorkout);
                  }
                },
                child: Text('Add Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}