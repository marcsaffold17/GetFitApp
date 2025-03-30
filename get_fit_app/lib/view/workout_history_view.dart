import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Screen that shows old workouts submitted to the "Workouts" collection in Firestore
class WorkoutHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout History'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary
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
              return ListTile(
                title: Text(data['Title'] ?? 'No Title'),
                subtitle:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data['Day'] != null && data['Day'] is Timestamp)
                      Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format((data['Day'] as Timestamp).toDate())}',
                      ),
                    if (data['Day'] == null || data['Day'] is! Timestamp)
                      Text('Date: No Date'),

                    Text('Type: ${data['Type'] ?? 'No Type'}'),
                    Text('Time: ${data['Time'] ?? 'No Time'}'),
                    Text('Distance: ${data['Distance'] ?? 'No Distance'}'),
                    Text('Description: ${data['Description'] ?? 'No Description'}'),
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
