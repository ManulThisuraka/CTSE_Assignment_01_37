import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChildrenRepository {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final CollectionReference _children =
      FirebaseFirestore.instance.collection('children');

  // Get all children
  Future getAllChildren() async {
    return _children..where('uid', isEqualTo: uid).snapshots();
  }

  // Add new children
  Future addChildren(String title, String description, String imageUrl) async {
    return await _children.add({
      "title": title,
      "description": description,
      "ingredients": ["sample01", "sample02"],
      "uid": uid,
      "imageUrl": imageUrl,
    });
  }

  // Update children
  Future<void> updateChildren(
      String id, String title, String description) async {
    return await _children.doc(id).update({
      "title": title,
      "description": description,
      "ingredients": ["sample01Updated", "sample02Updated"],
    });
  }

  // Delete children
  Future deleteChildren(id) async {
    await _children.doc(id).delete();
  }
}
