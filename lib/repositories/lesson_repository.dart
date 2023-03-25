import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LessonRepository {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final CollectionReference _lessons =
      FirebaseFirestore.instance.collection('lessons');

  // Get all homeworks
  Future getAllLessons() async {
    return _lessons..where('uid', isEqualTo: uid).snapshots();
  }

  // Add new homework
  Future addLesson(String title, String description, String submission) async {
    return await _lessons.add({
      "title": title,
      "description": description,
      "submission": submission,
      "items": ["sample01", "sample02"],
      "date": DateTime.now(),
      "uid": uid
    });
  }

  // Update homework
  Future<void> updateLesson(
      String id, String title, String description, String submission) async {
    return await _lessons.doc(id).update({
      "title": title,
      "description": description,
      "submission": submission,
      "items": ["sample01Updated", "sample02Updated"],
      "date": DateTime.now(),
    });
  }

  // Delete homework
  Future deleteLesson(id) async {
    await _lessons.doc(id).delete();
  }
}
