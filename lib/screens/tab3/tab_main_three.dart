import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_lab03_inclass_01/repositories/food_repository.dart';
import 'package:ctse_lab03_inclass_01/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabMainThreePage extends StatefulWidget {
  final User? user;
  const TabMainThreePage({Key? key, this.animationController, this.user})
      : super(key: key);

  final AnimationController? animationController;
  @override
  State<TabMainThreePage> createState() => _TabMainThreePageState();
}

class _TabMainThreePageState extends State<TabMainThreePage> {
  final TextEditingController _foodTitleController = TextEditingController();
  final TextEditingController _foodDescriptionController =
      TextEditingController();
  final TextEditingController _foodAllocationController =
      TextEditingController();

  final uid = FirebaseAuth.instance.currentUser?.uid;

//Add Meal Plan Function
  Future<void> _create(User user, [DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _foodTitleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _foodDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _foodAllocationController,
                  decoration:
                      const InputDecoration(labelText: 'Allocated Date'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String title = _foodTitleController.text;
                    final String description = _foodDescriptionController.text;
                    final String allocatedDay = _foodAllocationController.text;
                    await FoodRepository()
                        .addFoods(title, description, allocatedDay);

                    _foodTitleController.text = '';
                    _foodDescriptionController.text = '';
                    _foodAllocationController.text = '';
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Successfully Added')));
                  },
                )
              ],
            ),
          );
        });
  }

//Update Meal Plan Function
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _foodTitleController.text = documentSnapshot['title'];
      _foodDescriptionController.text = documentSnapshot['description'];
      _foodAllocationController.text = documentSnapshot['allocatedDay'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _foodTitleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _foodDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _foodAllocationController,
                  decoration:
                      const InputDecoration(labelText: 'Allocated Date'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String title = _foodTitleController.text;
                    final String description = _foodDescriptionController.text;
                    final String allocatedDay = _foodAllocationController.text;
                    final String id = documentSnapshot!.id;

                    await FoodRepository()
                        .updateFoods(id, title, description, allocatedDay);
                    _foodTitleController.text = '';
                    _foodDescriptionController.text = '';
                    _foodAllocationController.text = '';
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Successfully Updated')));
                  },
                )
              ],
            ),
          );
        });
  }

//Delete Meal Plan Function
  Future<void> _delete(String recipeId) async {
    await FoodRepository().deleteFoods(recipeId);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Successfully Deleted')));
  }

  Future<void> dialogBox(String lessonId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Meal Plan'),
            content:
                const Text('Are you sure you want to delete this meal plan?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  _delete(lessonId);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Meal Planner')),
          leading: GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.menu,
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.search,
                    size: 26.0,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    await FirebaseAuth.instance.signOut();
                    navigator.pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: Icon(Icons.logout),
                )),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('foods')
              .where('uid', isEqualTo: uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['title']),
                      subtitle: Text(documentSnapshot['description']),
                      leading: Text(documentSnapshot['allocatedDay']),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _update(documentSnapshot)),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    dialogBox(documentSnapshot.id)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 60.0),
            child: FloatingActionButton(
                onPressed: () => _create(widget.user!),
                child: const Icon(Icons.add))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
