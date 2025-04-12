import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Screen that shows old workouts submitted to the "Workouts"
// collection in Firestore
class WorkoutHistoryScreen extends StatelessWidget {

  String timeFormat(int totalMinutes) {
    if (totalMinutes < 60) {
      return '$totalMinutes minutes';
    } else {
      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;
      return '${hours}hr ${minutes}min';
    }
  }

  String averageSpeed(double distance, int time) {
    double averageSpeed = distance / (time / 60);
    return '${averageSpeed.toStringAsFixed(2)} mph';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar
        (title: Text('Workout History')
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Workouts')
            .orderBy('Day', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final workouts = snapshot.data!.docs;
          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              final data = workout.data() as Map<String, dynamic>;
              return Theme(
                data: Theme.of(context).copyWith(
                  
                  // Will probably need to rework the color scheming
                  expansionTileTheme: ExpansionTileThemeData(
                    backgroundColor: Colors.grey[200],
                    collapsedBackgroundColor: Colors.white,
                    tilePadding: EdgeInsets.symmetric(horizontal: 16),
                    childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(data['Title'] ?? 'No Title'),
                      if (data['Day'] != null && data['Day'] is Timestamp)
                        Text(
                          'Date: ${DateFormat('yyyy-MM-dd').format(
                              (data['Day'] as Timestamp).toDate())}',
                        ),
                      if (data['Day'] == null || data['Day'] is! Timestamp)
                        Text('Date: No Date'),
                    ],
                  ),
                  children: <Widget>[
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${data['Description'] ?? 'No Description'}'),
                          Text('Type: ${data['Type'] ?? 'No Type'}'),
                          Text(
                              'Time: ${data['Time'] != null ? timeFormat(data['Time']) : 'No Time'}'),
                          Text('Distance: ${data['Distance'] ?? 'No Distance'} mi'),
                          Text('Average Speed: ${data['Distance'] != null && data['Time'] != null
                              ? averageSpeed(data['Distance'], data['Time'])
                              : 'No Data'}'),
                          if (data['imageURL'] != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Image.network(
                                data['imageURL'],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
