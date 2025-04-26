import 'package:cloud_firestore/cloud_firestore.dart';

class ChartModel {
  final int x;
  final double y;
  final String name;

  ChartModel({required this.x, required this.y, required this.name});

  factory ChartModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    print(
      'Data Y: ${data['y']}',
    ); // This will print the value of 'y' for debugging
    return ChartModel(
      x: data['x'] ?? 0,
      y: (data['y'] is double) ? data['y'] : (data['y']?.toDouble() ?? 0.0),
      name: data['name'] ?? '',
    );
  }

  static Future<List<ChartModel>> fetchData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('chartData').get();

    return snapshot.docs.map((doc) => ChartModel.fromFirestore(doc)).toList();
  }
}
