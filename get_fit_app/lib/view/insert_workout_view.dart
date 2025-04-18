import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../presenter/insert_workout_presenter.dart';
import '../model/insert_workout_model.dart';
import '../view/workout_history_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
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

  WorkoutEntryScreen({required this.presenter});

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

  // List of workout types the user can choose from
  // Constantly expanding based on demand
  final List<Map<String, dynamic>> _workoutTypes = [
    {'name': 'Run', 'icon': Icons.directions_run},
    {'name': 'Bike', 'icon': Icons.directions_bike},
    {'name': 'Hike', 'icon': Icons.hiking},

    // hike, walk, roller ski, inline skate,
    // Swim, canoe, kayak,
    // alpine ski, nordic ski, ice skate, snowboard, snowshoe
    // weight training, rock climb, yoga, boxing, kickboxing, crossfit,
    // basketball, football, tennis, pickleball, volleyball, badminton, soccer, golf, table tennis,
    // any other types of workouts I can think of
  ];
  File? _image;

  @override
  void initState() {
    super.initState();
    _dayController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void onWorkoutAdded() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Workout Successfully Uploaded!'),
        duration: Duration(seconds: 2),
      ),
    );

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

  String? FormattedDate;
  // Startup UI, should probably adjust later to fit
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 244, 238, 227)),
        backgroundColor: Color.fromARGB(255, 20, 50, 31),
        title: Text(
          'Add Workout',
          style: TextStyle(color: Color.fromARGB(255, 244, 238, 227)),
        ),
      ),

      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Color.fromARGB(255, 81, 163, 108),
      //         ),
      //         child: Text(
      //           'Debug Menu',
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: 24,
      //             ),
      //           ),
      //       ),
      //       ListTile(
      //         title: Text('View Old Workouts'),
      //         onTap: () {
      //           Navigator.pop(context);
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => WorkoutHistoryScreen()),
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
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
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  // textAlign: TextAlign.center,
                  cursorColor: Color.fromARGB(255, 81, 163, 108),
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 229, 221, 212),
                    filled: true,
                    hintText: 'Enter your workout title here!',
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
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  // textAlign: TextAlign.center,
                  cursorColor: Color.fromARGB(255, 81, 163, 108),
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 229, 221, 212),
                    filled: true,
                    hintText: 'Tell us about your workout! How did it go?',
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
                  maxLines: 3,
                ),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Type of Workout',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 200,
                            height: 50,
                            child: DropdownButtonFormField<String>(
                              value: _workoutType,
                              decoration: InputDecoration(
                                fillColor: Color.fromARGB(255, 229, 221, 212),
                                filled: true,
                                border: OutlineInputBorder(
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
                              items:
                                  _workoutTypes.map((workout) {
                                    return DropdownMenuItem<String>(
                                      value: workout['name'],
                                      child: Row(
                                        children: [
                                          Icon(
                                            workout['icon'],
                                            color: Color.fromARGB(
                                              255,
                                              196,
                                              76,
                                              76,
                                            ),
                                            size: 16, // smaller icon
                                          ),
                                          SizedBox(
                                            width: 6.0,
                                          ), // smaller spacing
                                          Text(
                                            workout['name'],
                                            style: TextStyle(
                                              fontSize: 13,
                                            ), // smaller text
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _workoutType = newValue;
                                  _typeController.text = newValue ?? '';
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a workout type';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            // Handle pickedDate if needed
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 229, 221, 212),
                            minimumSize: const Size(150, 50),
                          ),
                          icon: Icon(
                            Icons.calendar_today_outlined,
                            color: Color.fromARGB(255, 20, 50, 31),
                            size: 18,
                          ),
                          label: Text(
                            'Date',
                            style: TextStyle(
                              color: Color.fromARGB(255, 20, 50, 31),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Garet',
                              fontSize: 15,
                            ),
                          ),
                        ),

                        // IconButton(
                        //   icon: Icon(Icons.calendar_month_outlined),
                        //   color: Color.fromARGB(255, 81, 163, 108),
                        // onPressed: () async {
                        //   final DateTime? pickedDate = await showDatePicker(
                        //     context: context,
                        //     initialDate: DateTime.now(),
                        //     firstDate: DateTime(2000),
                        //     lastDate: DateTime(2100),
                        //   );
                        //     if (pickedDate != null) {
                        //       FormattedDate = DateFormat(
                        //         'MM-dd-yyyy',
                        //       ).format(pickedDate);
                        //     }
                        //   },
                        // ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Time',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: TextFormField(
                                controller: _timeController,
                                textAlign: TextAlign.center,
                                cursorColor: Color.fromARGB(255, 81, 163, 108),
                                decoration: InputDecoration(
                                  hintText: '0.0',
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
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 81, 163, 108),
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 5),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'mins',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Distance',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.20,
                              child: TextFormField(
                                controller: _distanceController,
                                textAlign: TextAlign.center,
                                cursorColor: Color.fromARGB(255, 81, 163, 108),
                                decoration: InputDecoration(
                                  hintText: '0.0',
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
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 81, 163, 108),
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(width: 5),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'miles',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 229, 221, 212),
                          ),
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Color.fromARGB(255, 81, 163, 108),
                          ),
                          label: Text(
                            'Add\nPhoto',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      width: 175.0,
                      height: 175.0,
                      child: Image.file(_image!),
                    ),
                  ),
                SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
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

                          // Workout without image
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

                          // ⬇️ Make sure globalUsername is not null
                          if (globalUsername != null) {
                            widget.presenter.addWorkout(
                              newWorkout,
                              FormattedDate!,
                            );
                          } else {
                            print("Error: Username is null");
                          }
                          return;
                        }
                      }
                      final newWorkout = Workout(
                        day: Timestamp.fromDate(
                          DateTime.parse(_dayController.text),
                        ),
                        description: _descriptionController.text,
                        distance: distance,
                        time: time,
                        title: _titleController.text,
                        type: _typeController.text,
                        image: uploadedImageUrl,
                      );

                      // ⬇️ Again, check for null
                      if (globalUsername != null) {
                        widget.presenter.addWorkout(newWorkout, FormattedDate!);
                      } else {
                        print("Error: Username is null");
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 38, 92, 60),
                    padding: EdgeInsets.symmetric(
                      horizontal: 75.0,
                      vertical: 20.0,
                    ),
                    textStyle: TextStyle(fontSize: 20.0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
