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
    _dayController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void onWorkoutAdded() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Workout Successfully Uploaded!'),
      duration: Duration(seconds: 2),
    ));

    // Removing user input text fields after workout is added
    _formKey.currentState?.reset();
    _dayController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _descriptionController.clear();
    _distanceController.clear();
    _timeController.clear();
    _titleController.clear();
    _typeController.clear();
    _image = null;
    setState(() {});
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
      appBar: AppBar(
        title: Text('Add Workout'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Debug Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
            ),
            ListTile(
              title: Text('View Old Workouts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WorkoutHistoryScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Workout Title',
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                ),
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Workout Description'),
                maxLines: 3,
              ),

              TextFormField(
                      controller: _typeController,
                      decoration: InputDecoration(labelText: 'Type of Workout'),
                      keyboardType: TextInputType.text,
                    ),

              TextFormField(
                      controller: _timeController,
                      decoration: InputDecoration(labelText: 'Time (Minutes)'),
                      keyboardType: TextInputType.number,
                    ),
                  SizedBox(width: 16.0),

              TextFormField(
                      controller: _distanceController,
                      decoration: InputDecoration(labelText: 'Distance (Miles)'),
                      keyboardType: TextInputType.number,
                    ),
              SizedBox(height: 16.0),

              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.add_a_photo),
                label: Text('Add Photo'),
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(
                    width: 250.0,
                    height: 250.0,
                    child: Image.file(_image!),
                  ),
                ),

              SizedBox(height: 16.0),
              Spacer(),
              ElevatedButton.icon(
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
                      image: uploadedImageUrl,
                    );
                    widget.presenter.addWorkout(newWorkout);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 75.0, vertical: 25.0),
                  textStyle: TextStyle(fontSize: 20.0),
                ),
                icon: Icon(Icons.upload),
                label: Text('Upload Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
