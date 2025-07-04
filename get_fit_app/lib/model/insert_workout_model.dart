import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../presenter/global_presenter.dart';

// Code mainly deals with user inputted code from the view.
// Converts user inputted data into strings Firestore can understand.
class Workout {
  String? id;
  Timestamp day;
  String description;
  double distance;
  int time;
  String title;
  String type;
  String? image;

  Workout({
    this.id,
    required this.day,
    required this.description,
    required this.distance,
    required this.time,
    required this.title,
    required this.type,
    this.image,
  });

  // Factory for creating a workout
  factory Workout.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Workout(
      id: doc.id,
      day: data['Day'] as Timestamp? ?? Timestamp.now(),
      description: data['Description'] ?? '',
      distance: data['Distance'] ?? 0,
      time: data['Time'] ?? 0,
      title: data['Title'] ?? '',
      type: data['Type'] ?? '',
      image: data['imageURL'] ?? '',
    );
  }

  // Convert workout to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'Day': day,
      'Description': description,
      'Distance': distance,
      'Time': time,
      'name': title,
      'Type': type,
      'imageURL': image,
    };
  }
}

class WorkoutRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addWorkout({
    required String username,
    required String formattedDate,
    required Workout workout,
  }) async {
    try {
      await _firestore
          .collection('Login-Info')
          .doc(username)
          .collection('Workout-Plan')
          .doc(formattedDate)
          .set({
            'date': formattedDate
          });
      await _firestore
          .collection('Login-Info')
          .doc(username)
          .collection('Workout-Plan')
          .doc(formattedDate)
          .collection('Workout')
          .doc(workout.title) // use title as document ID
          .set(workout.toMap());
    } catch (e) {
      print("Error adding workout: $e");
    }
  }
}

