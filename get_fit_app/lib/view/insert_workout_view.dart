import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../presenter/insert_workout_presenter.dart';
import '../model/insert_workout_model.dart';
import '../view/workout_history_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Required when needing to authenticate user
// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

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
  File? _image;

  @override
  void initState() {
    super.initState();
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
    _image = null;
  }

  // User adds photo from camera roll to workout
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected');
      }
    });
  }

  Future<String?> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child
        ('Workout-Images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final UploadTask uploadTask = storageRef.putFile(image);

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
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
                onPressed: _pickImage,
                child: Text('Add Photo'),
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.file(_image!, height: 100),
                ),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    widget.presenter.view = this;
                    double? distance = double.tryParse(
                        _distanceController.text) ?? 0.0;
                    int? time = int.tryParse(_timeController.text) ?? 0;

                    String? uploadedImageUrl;
                    if (_image != null) {
                      uploadedImageUrl = await uploadImage(_image!);
                      if (uploadedImageUrl == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Photo upload failed, uploading without photo'),
                              duration: Duration(seconds: 3)),
                        );

                        // Workout without image
                        final newWorkout = Workout(
                          day: Timestamp.fromDate(DateTime.parse(_dayController.text)),
                          description: _descriptionController.text,
                          distance: distance,
                          time: time,
                          title: _titleController.text,
                          type: _typeController.text,
                          image: null,
                        );
                        widget.presenter.addWorkout(newWorkout);
                        return;
                      }
                    }

                    // Workout with image
                    final newWorkout = Workout(
                      day: Timestamp.fromDate(DateTime.parse(_dayController.text)),
                      description: _descriptionController.text,
                      distance: distance,
                      time: time,
                      title: _titleController.text,
                      type: _typeController.text,
                      image: uploadedImageUrl != null ? File(uploadedImageUrl) : null,
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
