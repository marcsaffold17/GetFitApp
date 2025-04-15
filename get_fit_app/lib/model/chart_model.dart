class ChartModel {
  final int x;
  final double y;
  final String name;

  ChartModel({required this.x, required this.y, required this.name});

  static Future<List<ChartModel>> fetchData() async {
    return [
      ChartModel(x: 0, y: 1, name: "bill"),
      ChartModel(x: 1, y: 1.5, name: "bill"),
      ChartModel(x: 2, y: 1.4, name: "bill"),
      ChartModel(x: 3, y: 3.4, name: "bill"),
      ChartModel(x: 4, y: 2, name: "bill"),
      ChartModel(x: 5, y: 2.2, name: "bill"),
      ChartModel(x: 6, y: 1.8, name: "bill"),
    ];
  }
}
