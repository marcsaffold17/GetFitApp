import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'LeaderboardPage.dart';
import 'package:get_fit_app/view/LeaderboardPage.dart';
import 'nav_bar.dart';
import '../presenter/global_presenter.dart';
import '../model/chart_model.dart';
import '../view/chart_veiw.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Workout_list_view.dart';
import '../view/favorites_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../view/WorkoutHistory.dart';
import '../view/profile_page.dart';
import '../view/checklist_view.dart';

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
  Color _chartColor = Colors.blue; // Default chart color
  bool _isLoading = true;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadChartPreference().then((_) {
      _loadChartData();
    });
    _loadProfileImage();
  }

  void _loadUsername() {
    userName = widget.username;
  }

  Future<void> _loadChartData() async {
    try {
      List<ChartModel> chartData = await ChartModel.fetchData();
      setState(() {
        _chartData = chartData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error fetching chart data: $e");
    }
  }

  Future<void> _loadChartPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedChart = prefs.getString('selectedChart') ?? 'Line';
      final colorHex = prefs.getString('chartColor') ?? 'FF2196F3';
      _chartColor = Color(int.parse('0x$colorHex'));
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

  // Callback function to refresh the chart
  void _refreshChart() {
    setState(() {
      _loadChartData();
    });
  }

  Widget _buildHomePage() {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 238, 227),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Back,",
              style: TextStyle(fontSize: 30, fontFamily: 'MontserratB'),
            ),
            Text(
              "$userName",
              style: const TextStyle(fontSize: 27, fontFamily: 'MontserratB'),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              height: 300,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 229, 221, 212),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color.fromARGB(255, 20, 50, 31),
                  width: 2,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: displayChart(_chartData, _selectedChart, _chartColor),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 379.4,
                  height: 70,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.checklist_rounded,
                      color: Color.fromARGB(255, 229, 221, 212),
                      size: 35,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 46, 105, 70),
                    ),
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChecklistPage(isFromNavbar: false),
                        ),
                      );
                    },
                    label: const Text(
                      "Check List",
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 379.4,
                  height: 70,
                  child: ElevatedButton.icon(
                    icon: const Icon(
                      Icons.emoji_events,
                      color: Color.fromARGB(255, 229, 221, 212),
                      size: 35,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 46, 105, 70),
                    ),
                    onPressed: () async {
                      // Pass the chart color to the LeaderboardPage
                      final updatedChart = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => LeaderboardPage(
                                chartColor: _chartColor,
                                isFromNavbar: false, // Pass color here
                              ),
                        ),
                      );
                      if (updatedChart != null) {
                        setState(() {
                          _chartColor =
                              updatedChart; // Update color after returning
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
    final List<Widget> pages = [
      _buildHomePage(),
      ExercisePage(onWorkoutAdded: _refreshChart),
      FavoritesPage(),
      WorkoutHistoryByDate(),
      LeaderboardPage(
        chartColor: _chartColor,
        isFromNavbar: false, // Pass chart color to LeaderboardPage
      ),
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
            padding: const EdgeInsets.only(right: 104),
            child: Image.asset(
              'assets/images/MachoMuscleMania.png',
              height: 300,
              width: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(username: userName),
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
        textStyle: const TextStyle(
          color: Color.fromARGB(255, 244, 238, 227),
          fontFamily: 'MontserratB',
        ),
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
