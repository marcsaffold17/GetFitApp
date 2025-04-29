
class Exercise {
  final String name;
  final String type;
  final String muscle;
  final String equipment;
  final String difficulty;
  final String instructions;
  final String? cardioType;
  bool isFavorite;

  Exercise({
    required this.name,
    required this.type,
    required this.muscle,
    required this.equipment,
    required this.difficulty,
    required this.instructions,
    required this.isFavorite,
    this.cardioType,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      type: json['type'],
      muscle: json['muscle'],
      equipment: json['equipment'],
      difficulty: json['difficulty'],
      instructions: json['instructions'],
      isFavorite: false,
    );
  }
}
