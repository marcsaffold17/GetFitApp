import 'package:flutter/material.dart';
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
              Row(
                children:[
                  Expanded(
                    child: TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Workout Title',
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                      ),
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _dayController,
                      decoration: InputDecoration(
                        labelText: 'Date (YYYY-MM-DD)',
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ]
              ),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Workout Description'),
                keyboardType: TextInputType.text,
              ),

              Row(
                children: [
                  Expanded (
                    child: TextFormField(
                      controller: _typeController,
                      decoration: InputDecoration(labelText: 'Type of Workout'),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(labelText: 'Time (Minutes)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _distanceController,
                      decoration: InputDecoration(labelText: 'Distance (Miles)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 400.0),
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
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
                ),
                child: Text('Add Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}