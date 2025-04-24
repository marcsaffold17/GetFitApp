// import 'dart:nativewrappers/_internal/vm/lib/ffi_patch.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../presenter/insert_workout_presenter.dart';
import '../model/insert_workout_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../presenter/global_presenter.dart';

// Required when needing to authenticate user
// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

abstract class WorkoutView {
  void onWorkoutAdded();
}

class WorkoutEntryScreen extends StatefulWidget {
  final WorkoutPresenter presenter;
  final VoidCallback? onWorkoutUploaded;

  WorkoutEntryScreen({required this.presenter, this.onWorkoutUploaded});

  @override
  _WorkoutEntryScreenState createState() => _WorkoutEntryScreenState();
}

// Initializing various text fields for inserting workout data
class _WorkoutEntryScreenState extends State<WorkoutEntryScreen>
    implements WorkoutView {
  final _formKey = GlobalKey<FormState>();
  final _dayController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _distanceController = TextEditingController();
  final _timeController = TextEditingController();
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  String? _workoutType;
  IconData? _workoutTypeIcon;

  File? _image;
  String? _dropdownError;
  String? _dateError;

  @override
  void initState() {
    super.initState();
    _dayController.text = DateFormat('MM-dd-yyyy').format(DateTime.now());
  }

  @override
  void onWorkoutAdded() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Workout Successfully Uploaded!'),
        duration: Duration(seconds: 2),
      ),
    );

    _formKey.currentState?.reset();
    _dayController.text = DateFormat('MM-dd-yyyy').format(DateTime.now());
    _descriptionController.clear();
    _distanceController.clear();
    _timeController.clear();
    _titleController.clear();
    _typeController.clear();
    _image = null;
    setState(() {});
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    try {
      DateFormat('MM-dd-yyyy').parse(value);
      return null; // Return null if valid
    } catch (e) {
      return 'Please enter a valid date (MM-DD-YYYY)';
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

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
      final storageRef = FirebaseStorage.instance.ref().child(
        'Workout-Images/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      final UploadTask uploadTask = storageRef.putFile(image);

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  void _showWorkoutTypeBottomSheet(BuildContext context) {
    final List<Map<String, dynamic>> workoutTypes = [
      {'type': 'Run', 'icon': Icons.directions_run},
      {'type': 'Walk', 'icon': Icons.directions_walk},
      {'type': 'Hike', 'icon': Icons.hiking},
      {'type': 'Bike', 'icon': Icons.directions_bike},
      {'type': 'Inline Skate', 'icon': Icons.roller_skating},
      {'type': 'Roller Ski', 'icon': Icons.roller_skating},
      {'type': 'Swim', 'icon': Icons.pool},
      {'type': 'Canoe', 'icon': Icons.kayaking},
      {'type': 'Kayak', 'icon': Icons.kayaking},
      {'type': 'Alpine Ski', 'icon': Icons.downhill_skiing},
      {'type': 'Nordic Ski', 'icon': Icons.downhill_skiing},
      {'type': 'Snowboard', 'icon': Icons.snowboarding},
      {'type': 'Ice Skate', 'icon': Icons.ice_skating},
      {'type': 'Snowshoe', 'icon': Icons.snowshoeing},
      {'type': 'Weight Training', 'icon': Icons.fitness_center},
      {'type': 'Rock Climb', 'icon': Icons.landscape},
      {'type': 'Yoga', 'icon': Icons.self_improvement},
      {'type': 'Crossfit', 'icon': Icons.fitness_center},
      {'type': 'StairMaster', 'icon': Icons.stairs},
      {'type': 'Pickleball', 'icon': Icons.sports_tennis},

      // More activities
    ];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children:
              workoutTypes.map((workout) {
                return ListTile(
                  leading: Icon(workout['icon'] as IconData),
                  title: Text(workout['type'] as String),
                  onTap: () {
                    setState(() {
                      _workoutType = workout['type'];
                      _workoutTypeIcon = workout['icon'];
                      _typeController.text = _workoutType!;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
        );
      },
    );
  }

  String? FormattedDate;
  @override
  TextStyle selectedStyle = TextStyle(
    fontFamily: 'rubikL',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Color.fromARGB(255, 46, 105, 70),
  );

  TextStyle unselectedStyle = TextStyle(
    fontFamily: 'RubikL',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Color.fromARGB(160, 46, 105, 70),
  );

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 244, 238, 227)),
        backgroundColor: Color.fromARGB(255, 20, 50, 31),
        title: Text(
          'Add Workout',
          style: TextStyle(
            color: Color.fromARGB(255, 244, 238, 227),
            fontFamily: 'RubikL',
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Title',
                    style: TextStyle(
                      fontFamily: 'RubikL',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 20, 50, 31),
                    ),
                  ),
                ),
                BigTextFormEditing(
                  titleController: _titleController,
                  maxLine: 1,
                  hintText: 'Enter workout title',
                ),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontFamily: 'RubikL',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 20, 50, 31),
                    ),
                  ),
                ),
                BigTextFormEditing(
                  titleController: _descriptionController,
                  maxLine: 3,
                  hintText: 'Enter workout description',
                ),
                SizedBox(height: 15.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Type of Workout',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'rubikL',
                      color: Color.fromARGB(255, 20, 50, 31),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showWorkoutTypeBottomSheet(context),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 229, 221, 212),
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _workoutTypeIcon,
                          color: Color.fromARGB(255, 20, 50, 31),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _workoutType ?? 'Select workout type',
                          style:
                              _workoutType == null
                                  ? unselectedStyle
                                  : selectedStyle,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InputFunctions(
                        timeController: _timeController,
                        hintText: '0:00 Mins',
                        text: 'Time',
                      ),
                      SizedBox(width: 15),
                      InputFunctions(
                        timeController: _distanceController,
                        hintText: '0.0 Miles',
                        text: 'Distance',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 175,
                                height: 50,
                                child: TextFormField(
                                  controller: _dayController,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'RubikL',
                                    color:
                                        _dateError == null
                                            ? Color.fromARGB(255, 46, 105, 70)
                                            : Colors.red,
                                  ),
                                  decoration: InputDecoration(
                                    fillColor: Color.fromARGB(
                                      255,
                                      229,
                                      221,
                                      212,
                                    ),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(
                                          255,
                                          81,
                                          163,
                                          108,
                                        ),
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 46, 105, 70),
                                        width: 2.0,
                                      ),
                                    ),
                                    hintText: 'MM-DD-YYYY',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.calendar_today_outlined,
                                        color: Color.fromARGB(
                                          255,
                                          81,
                                          163,
                                          108,
                                        ),
                                      ),
                                      onPressed: () async {
                                        final DateTime? pickedDate =
                                            await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                            );

                                        if (pickedDate != null) {
                                          setState(() {
                                            _dayController.text = DateFormat(
                                              'MM-dd-yyyy',
                                            ).format(pickedDate);
                                            FormattedDate = DateFormat(
                                              'MM-dd-yyyy',
                                            ).format(pickedDate);
                                            _dateError = _validateDate(
                                              _dayController.text,
                                            );
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 175,
                                height: 50,
                                child: TextButton.icon(
                                  onPressed: _pickImage,
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      229,
                                      221,
                                      212,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.add_a_photo_outlined,
                                    color: Color.fromARGB(255, 81, 163, 108),
                                    size: 22.5,
                                  ),
                                  label: Text(
                                    'Add Photo',
                                    style: TextStyle(
                                      fontFamily: 'RubikL',
                                      color: Color.fromARGB(255, 46, 105, 70),
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: 175.0,
                      height: 175.0,
                      child: Image.file(_image!),
                    ),
                  ),
                if (_dateError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      _dateError!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontFamily: 'RubikL',
                      ),
                    ),
                  ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 244, 238, 227),
        padding: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
        // padding: EdgeInsets.all(20.0),
        child: ElevatedButton.icon(
          onPressed: () async {
            setState(() {
              print(_dateError);
              _dropdownError =
                  _workoutType == null ? 'Please select a workout type' : null;
              _dateError = _validateDate(_dayController.text);
            });

            if (_formKey.currentState!.validate() &&
                _dropdownError == null &&
                _dateError == null) {
              widget.presenter.view = this;
              double? distance =
                  double.tryParse(_distanceController.text) ?? 0.0;
              int? time = int.tryParse(_timeController.text) ?? 0;
              String? uploadedImageUrl;

              if (_image != null) {
                uploadedImageUrl = await uploadImage(_image!);
                if (uploadedImageUrl == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Photo upload failed, uploading without photo',
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  final newWorkout = Workout(
                    day: Timestamp.fromDate(
                      DateTime.parse(_dayController.text),
                    ),
                    description: _descriptionController.text,
                    distance: distance,
                    time: time,
                    title: _titleController.text,
                    type: _typeController.text,
                    image: null,
                  );
                  if (globalUsername != null) {
                    widget.presenter.addWorkout(newWorkout, FormattedDate!);
                  } else {
                    print("Error: Username is null");
                  }
                  return;
                }
              }

              DateTime parsedDate = DateFormat(
                'MM-dd-yyyy',
              ).parse(_dayController.text);
              final newWorkout = Workout(
                day: Timestamp.fromDate(parsedDate),
                description: _descriptionController.text,
                distance: distance,
                time: time,
                title: _titleController.text,
                type: _typeController.text,
                image: uploadedImageUrl,
              );

              if (globalUsername != null && FormattedDate != null) {
                widget.presenter.addWorkout(newWorkout, FormattedDate!);
                if (widget.onWorkoutUploaded != null) {
                  widget.onWorkoutUploaded!();
                }
                Navigator.pop(context);
              } else {
                print("Error: Username is null");
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 38, 92, 60),
            padding: EdgeInsets.symmetric(horizontal: 75.0, vertical: 20.0),
            textStyle: TextStyle(fontSize: 20.0, fontFamily: 'MontserratB'),
          ),
          icon: Icon(
            Icons.upload,
            color: Color.fromARGB(255, 244, 238, 227),
            size: 25,
          ),
          label: Text(
            'Upload Workout',
            style: TextStyle(color: Color.fromARGB(255, 244, 238, 227)),
          ),
        ),
      ),
    );
  }
}

class InputFunctions extends StatelessWidget {
  const InputFunctions({
    super.key,
    required TextEditingController timeController,
    required this.hintText,
    required this.text,
  }) : _timeController = timeController;

  final TextEditingController _timeController;
  final String hintText;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'RubikL',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 20, 50, 31),
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 175,
              height: 50,
              child: SmallTextFormField(
                timeController: _timeController,
                hintText: hintText,
              ),
            ),
            // SizedBox(width: 5),
          ],
        ),
      ],
    );
  }
}

class BigTextFormEditing extends StatelessWidget {
  const BigTextFormEditing({
    super.key,
    required TextEditingController titleController,
    required this.maxLine,
    required this.hintText,
  }) : _titleController = titleController;

  final TextEditingController _titleController;
  final int maxLine;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _titleController,
      // textAlign: TextAlign.center,
      cursorColor: Color.fromARGB(255, 81, 163, 108),
      decoration: InputDecoration(
        fillColor: Color.fromARGB(255, 229, 221, 212),
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color.fromARGB(160, 46, 105, 70),
          fontFamily: 'RubikL',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 81, 163, 108),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 81, 163, 108),
            width: 2.0,
          ),
        ),
      ),
      maxLines: maxLine,
      keyboardType: TextInputType.text,
    );
  }
}

class SmallTextFormField extends StatelessWidget {
  const SmallTextFormField({
    super.key,
    required TextEditingController timeController,
    required this.hintText,
  }) : _timeController = timeController;

  final TextEditingController _timeController;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _timeController,
      textAlign: TextAlign.center,
      cursorColor: Color.fromARGB(255, 81, 163, 108),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color.fromARGB(160, 46, 105, 70),
          fontFamily: 'RubikL',
        ),
        fillColor: Color.fromARGB(255, 229, 221, 212),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 81, 163, 108),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 46, 105, 70),
            width: 2.0,
          ),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }
}
