import 'package:flutter/material.dart';
import '../view/login_view.dart';
import 'nav_bar.dart';
import 'chart_veiw.dart'; // Import chart_view to use displayChart function
import '../presenter/chart_presenter.dart';
import '../model/chart_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.username});
  final String title;
  final String username;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements ChartView {
  List<ChartModel> _chartData = [];
  late ChartPresenter _presenter;
  final String _selectedChart = 'Line';

  @override
  void initState() {
    super.initState();
    _presenter = ChartPresenter(this);
    _presenter.loadData();
  }

  @override
  void updateChart(List<ChartModel> data) {
    setState(() {
      _chartData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
      drawer: const NavBar(),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              "Welcome Back, ${widget.username}",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: displayChart(
              _chartData,
              _selectedChart,
            ), // Call displayChart function
          ),
        ],
      ),
    );
  }
}
