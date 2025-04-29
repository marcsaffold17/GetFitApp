import '../view/badge_screen.dart';
import '../view/insert_workout_view.dart';
import '../model/insert_workout_model.dart';
import '../presenter/global_presenter.dart';
import '../presenter/badge_presenter.dart';
import '../model/badge_model.dart';

class WorkoutPresenter {
  late WorkoutView view;
  final WorkoutRepository repository;

  WorkoutPresenter(this.repository);

  // Adds workout data user inserts in app to Firestore under correct structure
  Future<void> addWorkout(Workout workout, String formattedDate) async {
    try {
      await repository.addWorkout(
        username: globalUsername!, // or pass username as a parameter if needed
        formattedDate: formattedDate,
        workout: workout,
      );


      view.onWorkoutAdded();
    } catch (e) {
      print("Error adding workout: $e");
    }

  }
}
