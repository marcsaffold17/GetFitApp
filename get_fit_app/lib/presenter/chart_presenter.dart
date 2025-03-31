import '../model/chart_model.dart';

abstract class ChartView {
  void updateChart(List<ChartModel> data);
}

class ChartPresenter {
  final ChartView view;

  ChartPresenter(this.view);

  void loadData() async {
    List<ChartModel> data = await ChartModel.fetchData();
    view.updateChart(data);
  }
}
