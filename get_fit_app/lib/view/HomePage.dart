import 'package:flutter/material.dart';
import 'dart:ui';
import 'LeaderboardPage.dart';
import 'nav_bar.dart';
import '../presenter/global_presenter.dart';
import '../model/chart_model.dart'; // Make sure to import the ChartModel class
import '../view/chart_veiw.dart';
import 'settingspage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/exercise_view.dart';
import '../view/favorites_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../view/Workout-Plan.dart';
import '../view/profile_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.username});

  final String title;
  final String username;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late String userName;
  List<ChartModel> _chartData = [];
  String _selectedChart = 'Line';
  Color _chartColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadChartData(); // Load dynamic chart data
    _loadChartPreference();
  }

  void _loadUsername() {
    userName = widget.username; // Access username from widget
  }

  // Fetch the dynamic data for the chart from Firestore
  Future<void> _loadChartData() async {
    List<ChartModel> chartData =
        await ChartModel.fetchData(); // Fetch data from Firebase
    setState(() {
      _chartData = chartData; // Update the state with the fetched chart data
    });
  }

  Future<void> _loadChartPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedChart = prefs.getString('selectedChart') ?? 'Line';
      final colorHex =
          prefs.getString('chartColor') ?? 'FF2196F3'; // Default blue
      _chartColor = Color(int.parse('0x$colorHex'));
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
            "Welcome Back, $userName",
            style: const TextStyle(fontSize: 30),
          ),
        ),
        Positioned(
          top: 60,
          left: 20,
          child: ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
              await _loadChartPreference(); // Always reload preferences including color
              setState(() {}); // Rebuild the widget tree
            },
            child: const Text("Change Chart Settings"),
          ),
        ),
        Positioned(
          top: 120,
          left: 20,
          right: 20,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child:
                _chartData.isEmpty
                    ? const CircularProgressIndicator() // Show loading indicator while data is being fetched
                    : displayChart(_chartData, _selectedChart, _chartColor),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(),
      ExercisePage(),
      FavoritesPage(),
      WorkoutHistoryByDate(),
      LeaderboardPage(chartColor: _chartColor), // Pass color to LeaderboardPage
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 238, 227),
      appBar: AppBar(
        title: const Text(""),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 244, 238, 227),
        ),
        backgroundColor: const Color.fromARGB(255, 20, 50, 31),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(username: userName),
                  ),
                );
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/AshtonHall.webp'),
                radius: 18,
              ),
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      drawer: const NavBar(),
      body: pages[_selectedIndex],
      bottomNavigationBar: GNav(
        onTabChange: _onItemTapped,
        padding: const EdgeInsets.all(16),
        gap: 8,
        backgroundColor: const Color.fromARGB(255, 20, 50, 31),
        tabBackgroundColor: const Color.fromARGB(255, 49, 112, 75),
        tabBorderRadius: 12,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
            iconColor: Color.fromARGB(255, 244, 238, 227),
            iconActiveColor: Color.fromARGB(255, 244, 238, 227),
            textColor: Color.fromARGB(255, 244, 238, 227),
          ),
          GButton(
            icon: Icons.sports_handball_outlined,
            text: 'Exercise List',
            iconColor: Color.fromARGB(255, 244, 238, 227),
            iconActiveColor: Color.fromARGB(255, 244, 238, 227),
            textColor: Color.fromARGB(255, 244, 238, 227),
          ),
          GButton(
            icon: Icons.star_border_outlined,
            text: "Favorites",
            iconColor: Color.fromARGB(255, 244, 238, 227),
            iconActiveColor: Color.fromARGB(255, 244, 238, 227),
            textColor: Color.fromARGB(255, 244, 238, 227),
          ),
          GButton(
            icon: Icons.history,
            text: "Workout History",
            iconColor: Color.fromARGB(255, 244, 238, 227),
            iconActiveColor: Color.fromARGB(255, 244, 238, 227),
            textColor: Color.fromARGB(255, 244, 238, 227),
          ),
          GButton(
            icon: Icons.bar_chart_sharp,
            text: "Leaderboard",
            iconColor: Color.fromARGB(255, 244, 238, 227),
            iconActiveColor: Color.fromARGB(255, 244, 238, 227),
            textColor: Color.fromARGB(255, 244, 238, 227),
          ),
        ],
      ),
    );
  }
}

Widget displayChart(
  List<ChartModel> chartData,
  String selectedChart,
  Color chartColor,
) {
  if (chartData.isEmpty) return const SizedBox.shrink();
  return selectedChart == 'Line'
      ? LineChartWidget(
        key: const ValueKey('line'),
        data: chartData,
        color: chartColor,
      )
      : BarChartWidget(
        key: const ValueKey('bar'),
        data: chartData,
        color: chartColor,
      );
}
