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
  Future addChildren(String name, String birthDate, String imageUrl) async {
    return await _children.add({
      "name": name,
      "birthDate": birthDate,
      "uid": uid,
      "imageUrl": imageUrl,
    });
  }

  // Update children
  Future<void> updateChildren(
      String id, String name, String birthDate) async {
    return await _children.doc(id).update({
      "name": name,
      "birthDate": birthDate,
    });
  }

  // Delete children
  Future deleteChildren(id) async {
    await _children.doc(id).delete();
  }
}
