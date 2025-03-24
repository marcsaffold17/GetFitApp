import 'package:cloud_firestore/cloud_firestore.dart';

// Code mainly deals with user inputted code from the view.
// Converts user inputted data into strings Firestore can understand.
class Workout {
  String? id;
  String day;
  String description;
  String time;
  String title;
  String type;

  Workout({
    this.id,
    required this.day,
    required this.description,
    required this.time,
    required this.title,
    required this.type,
  });

  // Factory for creating a workout
  factory Workout.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Workout(
      id: doc.id,
      day: data['Day'] ?? '',
      description: data['Description'] ?? '',
      time: data['Time'] ?? '',
      title: data['Title'] ?? '',
      type: data['Type'] ?? '',
    );
  }

  // Convert workout to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'Day': day,
      'Description': description,
      'Time': time,
      'Title': title,
      'Type': type,
    };
  }
}

class WorkoutRepository {
  final CollectionReference workoutsCollection =
  FirebaseFirestore.instance.collection('Workouts');

  // Add workout to "Workouts" database in Firestore
  Future<void> addWorkout(Workout workout) async {
    try {
      await workoutsCollection.add(workout.toMap());
    } catch (e) {
      print("Error adding workout: $e");
    }
  }
}