import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final databaseReference = FirebaseFirestore.instance.collection('Workouts');

void insertWorkout() {
  databaseReference.doc("2").set(
      {"Day": "3/20", "Description": "Hit 1 rep max on bench, 45lbs! Big gains today", "Time": "1hr 20mins",
      "Title": "Chest Day!", "Type": "Lift"});

  // Other database inserts will go here
  }

