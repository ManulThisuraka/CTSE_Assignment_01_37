import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FoodRepository {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final CollectionReference _foods =
      FirebaseFirestore.instance.collection('foods');

  // Get all meal plans
  Future getAllFoods() async {
    return _foods..where('uid', isEqualTo: uid).snapshots();
  }

  // Add new meal plan
  Future addFoods(String title, String description, String allocatedDay) async {
    return await _foods.add({
      "title": title,
      "description": description,
      "allocatedDay": allocatedDay,
      "date": DateTime.now(),
      "uid": uid
    });
  }

  // Update meal plan
  Future<void> updateFoods(
      String id, String title, String description, String allocatedDay) async {
    return await _foods.doc(id).update({
      "title": title,
      "description": description,
      "allocatedDay": allocatedDay,
      "date": DateTime.now(),
    });
  }

  // Delete meal plan
  Future deleteFoods(id) async {
    await _foods.doc(id).delete();
  }
}
