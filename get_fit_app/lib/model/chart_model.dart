class ChartModel {
  final int x;
  final double y;

  ChartModel({required this.x, required this.y});

  static Future<List<ChartModel>> fetchData() async {
    return [
      ChartModel(x: 0, y: 1),
      ChartModel(x: 1, y: 1.5),
      ChartModel(x: 2, y: 1.4),
      ChartModel(x: 3, y: 3.4),
      ChartModel(x: 4, y: 2),
      ChartModel(x: 5, y: 2.2),
      ChartModel(x: 6, y: 1.8),
    ];
  }
}
