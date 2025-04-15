import '../view/insert_workout_view.dart';
import '../model/insert_workout_model.dart';

class WorkoutPresenter {
  late WorkoutView view;
  final WorkoutRepository repository;

  WorkoutPresenter(this.repository);

  // Adds workout data user inserts in app (code is in view) to Firestore
  // database (code is in model)
  Future<void> addWorkout(Workout workout) async {
    try {
      await repository.addWorkout(workout);
      view.onWorkoutAdded();
    } catch (e) {
      print("Error adding workout: $e");
    }
  }
}