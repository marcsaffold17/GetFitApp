import 'package:cloud_firestore/cloud_firestore.dart';

class ChartModel {
  final int x;
  final double y;
  final String name;

  ChartModel({required this.x, required this.y, required this.name});

  factory ChartModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChartModel(
      x: data['x'] ?? 0,
      y: (data['y'] ?? 0).toDouble(),
      name: data['name'] ?? '',
    );
  }

  static Future<List<ChartModel>> fetchData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('chartData').get();

    return snapshot.docs.map((doc) => ChartModel.fromFirestore(doc)).toList();
  }
}
