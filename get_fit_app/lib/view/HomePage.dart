import 'package:flutter/material.dart';
import 'package:get_fit_app/view/LeaderboardPage.dart';
import '../view/login_view.dart';
import 'nav_bar.dart';
import '../presenter/global_presenter.dart';
import '../model/chart_model.dart';
import '../view/chart_veiw.dart';
import 'settingspage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/exercise_view.dart';
import '../view/favorites_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../view/Workout-Plan.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.username});
  final String title;
  final String username;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
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
  }

  void _loadChartData() {
    _chartData = [
      ChartModel(x: 1, y: 5, name: "0"),
      ChartModel(x: 2, y: 6, name: "1"),
      ChartModel(x: 3, y: 7, name: "2"),
      ChartModel(x: 4, y: 8, name: "3"),
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomePage() {
    return Stack(
      children: [
        Positioned(
          top: 20,
          left: 20,
          child: Text(
            "Welcome Back, $UserName",
            style: const TextStyle(fontSize: 30),
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
              final updatedChart = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomePage(),
      ExercisePage(),
      FavoritesPage(),
      WorkoutHistoryByDate(),
      LeaderboardPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      drawer: const NavBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: GNav(
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        padding: EdgeInsets.all(16),
        gap: 8,
        tabBackgroundColor: const Color.fromARGB(255, 211, 208, 208)!,
        tabBorderRadius: 12,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        tabs: const [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.sports_handball_outlined, text: 'Exercise List'),
          GButton(icon: Icons.star_border_outlined, text: "Favorites"),
          GButton(icon: Icons.history, text: "Workout History"),
          GButton(icon: Icons.bar_chart_sharp, text: "LeaderBoard"),
        ],
      ),
    );
  }
}
