import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/exercies_model.dart';
import '../presenter/global_presenter.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Exercise> _favoriteExercises = [];

  final favoritesRef = FirebaseFirestore.instance
      .collection('Login-Info')
      .doc(globalUsername)
      .collection('favorites');

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final snapshot = await favoritesRef.get();

    setState(() {
      _favoriteExercises =
          snapshot.docs.map((doc) {
            final data = doc.data();
            return Exercise(
              name: data['name'],
              type: data['type'],
              muscle: data['muscle'],
              difficulty: data['difficulty'],
              equipment: data['equipment'],
              instructions: data['instructions'],
              isFavorite: true,
            );
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 238, 227),
      body:
          _favoriteExercises.isEmpty
              ? Center(
                child: Text(
                  "No favorites right now",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : ListView.builder(
                itemCount: _favoriteExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _favoriteExercises[index];

                  return Card(
                    color: Color.fromARGB(255, 229, 221, 212),
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        exercise.name,
                        style: TextStyle(
                          color: Color.fromARGB(255, 20, 50, 31),
                          fontFamily: 'MontserratB',
                        ),
                      ),
                      subtitle: Text(
                        "Difficulty: ${exercise.difficulty}\n"
                        "Equipment: ${exercise.equipment}",
                        style: TextStyle(
                          color: Color.fromARGB(255, 46, 105, 70),
                          fontFamily: 'RubikL',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () => _showDetails(exercise),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Color.fromARGB(200, 202, 59, 59),
                        ),
                        onPressed: () async {
                          await favoritesRef.doc(exercise.name).delete();
                          setState(() {
                            _favoriteExercises.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }

  void _showDetails(Exercise exercise) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 244, 238, 227),
          title: Text(
            exercise.name,
            style: TextStyle(
              color: Color.fromARGB(255, 20, 50, 31),
              fontFamily: 'MontserratB',
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  exercise.instructions,
                  style: TextStyle(
                    color: Color.fromARGB(255, 46, 105, 70),
                    fontFamily: 'RubikL',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              width: 100,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 229, 221, 212),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // side: BorderSide(
                    //   color: Color.fromARGB(255, 0, 0, 0),
                    //   width: 1,
                    // ),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Color.fromARGB(255, 202, 59, 59),
                    fontFamily: 'MonsterratB',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
