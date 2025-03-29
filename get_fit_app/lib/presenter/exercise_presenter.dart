import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/exercies_model.dart';

abstract class ExerciseView {
  void showExercises(List<Exercise> exercises);
  void showError(String message);
}

class ExercisePresenter {
  final ExerciseView view;
  final String apiKey = "1k1ZlfCKgi6LiAm0AtKgVw==wm9LHZEOibILwX0u"; 

  ExercisePresenter(this.view);

  Future<void> fetchMuscleExercises(String muscleType, String muscle) async {
  final url = Uri.parse("https://api.api-ninjas.com/v1/exercises?$muscleType=$muscle");

    try {
      final response = await http.get(
        url,
        headers: {"X-Api-Key": apiKey},
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Exercise> exercises = jsonData.map((e) => Exercise.fromJson(e)).toList();
        view.showExercises(exercises);
      } else {
        view.showError("Failed to load exercises");
      }
    } catch (e) {
      view.showError("An error occurred: $e");
    }
  }
}
