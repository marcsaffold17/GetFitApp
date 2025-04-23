import 'dart:io';
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
import '../view/WorkoutHistory.dart';
import '../view/profile_page.dart';
import '../view/checklist_view.dart';
import '../view/LeaderboardPage.dart';

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
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadChartData();
    _loadChartPreference();
    _loadProfileImage();
  }

  void _loadUsername() {
    UserName = globalUsername ?? widget.username;
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

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profileImage');
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _profileImage = File(imagePath);
      });
    } else {
      setState(() {
        _profileImage = null;
      });
    }
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back,",
              style: const TextStyle(fontSize: 30, fontFamily: 'MontserratB'),
            ),
            Text(
              "$UserName",
              style: const TextStyle(fontSize: 27, fontFamily: 'MontserratB'),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              height: 300,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 229, 221, 212),
                borderRadius: BorderRadius.circular(20),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: displayChart(_chartData, _selectedChart),
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 379.4,
                  height: 70,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.list,
                      color: Color.fromARGB(255, 229, 221, 212),
                      size: 35,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 46, 105, 70),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChecklistPage(),
                        ),
                      );
                    },
                    label: const Text(
                      "TODO List",
                      style: TextStyle(
                        color: Color.fromARGB(255, 244, 238, 227),
                        fontFamily: 'MontserratB',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 379.4,
                  height: 70,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.emoji_events,
                      color: Color.fromARGB(255, 229, 221, 212),
                      size: 35,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 46, 105, 70),
                    ),
                    onPressed: () async {
                      final updatedChart = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaderboardPage(),
                        ),
                      );
                      if (updatedChart != null) {
                        setState(() {
                          _selectedChart = updatedChart;
                        });
                      }
                    },
                    label: const Text(
                      "LeaderBoard",
                      style: TextStyle(
                        color: Color.fromARGB(255, 244, 238, 227),
                        fontFamily: 'MontserratB',
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomePage(),
      ExercisePage(),
      FavoritesPage(),
      WorkoutHistoryByDate(),
    ];

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      appBar: AppBar(
        title: const Text(""),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 244, 238, 227)),
        backgroundColor: Color.fromARGB(255, 20, 50, 31),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(username: UserName),
                  ),
                );
                _loadProfileImage();
              },
              child: CircleAvatar(
                radius: 18,
                backgroundImage:
                    _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/images/AshtonHall.webp')
                            as ImageProvider,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      drawer: const NavBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: GNav(
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        padding: const EdgeInsets.all(16),
        gap: 8,
        backgroundColor: Color.fromARGB(255, 20, 50, 31),
        tabBackgroundColor: Color.fromARGB(255, 49, 112, 75),
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
        ],
      ),
    );
  }
}

Widget displayChart(List<ChartModel> chartData, String selectedChart) {
  if (chartData.isEmpty) return const SizedBox.shrink();
  return selectedChart == 'Line'
      ? LineChartWidget(key: const ValueKey('line'), data: chartData)
      : BarChartWidget(key: const ValueKey('bar'), data: chartData);
}
