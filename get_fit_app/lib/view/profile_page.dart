import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _bio = '';
  File? _image;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bio = prefs.getString('bio') ?? '';
      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null && File(imagePath).existsSync()) {
        _image = File(imagePath);
      }
      _bioController.text = _bio;
    });
  }

  Future<void> _saveBio() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bio = _bioController.text;
    });
    await prefs.setString('bio', _bio);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _image = File(pickedFile.path);
      });
      await prefs.setString('profileImage', pickedFile.path);
    }
  }

  Widget _achievementCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required double progress,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Color.fromARGB(255, 229, 221, 212),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              color: color,
              backgroundColor: color.withOpacity(0.2),
              minHeight: 8,
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("My Workout Profile", style: TextStyle(color:  Color.fromARGB(255, 244, 238, 227)),),
        iconTheme: IconThemeData(
          color: Color.fromARGB(255, 244, 238, 227),
        ),
        backgroundColor: Color.fromARGB(255, 20, 50, 31),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      _image != null
                          ? FileImage(_image!)
                          : const AssetImage('assets/images/AshtonHall.webp')
                              as ImageProvider,
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.username,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About Me',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bioController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 229, 221, 212),
                filled: true,
                hintText: 'Write something about yourself...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 20, 50, 31),
                    width: 2,
                  ),
                ),
              ),
              maxLines: 3,
              onChanged: (value) => _saveBio(),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '🏋️ Achievements',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 16),
            _achievementCard(
              icon: Icons.emoji_events,
              color: Colors.amber,
              title: 'First Workout',
              subtitle: 'You completed your first workout!',
              progress: 1.0,
            ),
            const SizedBox(height: 12),
            _achievementCard(
              icon: Icons.local_fire_department,
              color: Colors.redAccent,
              title: 'Streak Master',
              subtitle: '7-day workout streak!',
              progress: 0.7,
            ),
            const SizedBox(height: 12),
            _achievementCard(
              icon: Icons.trending_up,
              color: Colors.green,
              title: 'Level Up',
              subtitle: 'You increased your max reps!',
              progress: 0.4,
            ),
          ],
        ),
      ),
    );
  }
}
