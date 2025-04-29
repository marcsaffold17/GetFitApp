import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/chart_model.dart';

abstract class ChartView {
  void updateChart(List<ChartModel> data);
}

class ChartPresenter {
  final ChartView view;

  ChartPresenter(this.view);

  // Updated loadData to fetch data from Firebase
  void loadData() async {
    // Fetch the data from Firestore
    List<ChartModel> data = await ChartModel.fetchData();
    view.updateChart(data);
  }
}
