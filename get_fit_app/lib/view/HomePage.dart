import 'package:flutter/material.dart';
import '../view/login_view.dart';
import 'nav_bar.dart';
import '../presenter/global_presenter.dart';
import '../model/chart_model.dart';
import '../presenter/global_presenter.dart';
import 'nav_bar.dart';
import '../view/chart_veiw.dart';
import 'settingspage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.username});
  final String title;
  final String username;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String UserName;
  List<ChartModel> _chartData = [];
  String _selectedChart = 'Line';

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadChartData();
    _loadChartPreference();
  }

  void _loadUsername() {
    UserName = globalUsername ?? widget.username;
  }

  void _logout() {
    setState(() {
      globalUsername = null;
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginButtonPage()),
      (Route<dynamic> route) => false,
    );
  void _loadChartData() {
    _chartData = [
      ChartModel(x: 1, y: 5),
      ChartModel(x: 2, y: 6),
      ChartModel(x: 3, y: 7),
      ChartModel(x: 4, y: 8),
    ];
  }

  Future<void> _loadChartPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedChart = prefs.getString('selectedChart') ?? 'Line';
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadChartPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      drawer: const NavBar(),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              "Welcome Back, $UserName",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Positioned(
            top: 70,
            left: 20,
            right: 20,
            child: displayChart(_chartData, _selectedChart),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            child: ElevatedButton(
              onPressed: () async {
                // Navigate to SettingsPage and await the result
                final updatedChart = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );

                // If the chart was updated, reload the preferences and update the chart
                if (updatedChart != null) {
                  setState(() {
                    _selectedChart = updatedChart;
                  });
                }
              },
              child: const Text("Change Chart Settings"),
            ),
          ),
        ],
      ),
    );
  }
}
