import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

//
class ActivityRepository {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final CollectionReference _activty =
      FirebaseFirestore.instance.collection('activty');

  // Get all activity 1
  Future getAllActivities() async {
    return _activty..where('uid', isEqualTo: uid).snapshots();
  }

  // Add new activity
  Future addActivity(String title, String description, String type) async {
    return await _activty.add({
      "title": title,
      "description": description,
      "type": type,
      "items": ["sample01", "sample02"],
      "date": DateTime.now(),
      "uid": uid
    });
  }

  // Update activity
  Future<void> updateActivity(
      String id, String title, String description, String type) async {
    return await _activty.doc(id).update({
      "title": title,
      "description": description,
      "type": type,
      "items": ["sample01Updated", "sample02Updated"],
      "date": DateTime.now(),
    });
  }

  // Delete activity
  Future deleteactivity(id) async {
    await _activty.doc(id).delete();
  }
}
