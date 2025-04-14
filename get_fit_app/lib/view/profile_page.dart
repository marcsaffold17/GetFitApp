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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Profile"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    _image != null
                        ? FileImage(_image!)
                        : const AssetImage('assets/images/AshtonHall.webp')
                            as ImageProvider,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 18,
                    child: Icon(Icons.edit, size: 18, color: Colors.grey[800]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
              onChanged: (value) => _saveBio(),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Achievements',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.amber),
                title: const Text('First Workout'),
                subtitle: const Text('You completed your first workout!'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.star, color: Colors.orange),
                title: const Text('Streak Master'),
                subtitle: const Text('7-day workout streak!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
