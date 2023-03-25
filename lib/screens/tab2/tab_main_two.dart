import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_lab03_inclass_01/repositories/activity_repository.dart';
import 'package:ctse_lab03_inclass_01/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//
class TabMainTwoPage extends StatefulWidget {
  final User? user;
  const TabMainTwoPage({Key? key, this.animationController, this.user})
      : super(key: key);

  final AnimationController? animationController;
  @override
  State<TabMainTwoPage> createState() => _TabMainTwoPageState();
}

class _TabMainTwoPageState extends State<TabMainTwoPage> {
  final TextEditingController _activityTitleController =
      TextEditingController();
  final TextEditingController _activityDescriptionController =
      TextEditingController();
  final TextEditingController _activityCategoryController =
      TextEditingController();

  final uid = FirebaseAuth.instance.currentUser?.uid;

//Add Activity Function
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
                  controller: _activityTitleController,
                  decoration: const InputDecoration(labelText: 'Activity Name'),
                ),
                TextField(
                  controller: _activityDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _activityCategoryController,
                  decoration: const InputDecoration(labelText: 'Activity Type'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String title = _activityTitleController.text;
                    final String description =
                        _activityDescriptionController.text;
                    final String type = _activityCategoryController.text;

                    await ActivityRepository()
                        .addActivity(title, description, type);

                    _activityTitleController.text = '';
                    _activityDescriptionController.text = '';
                    _activityCategoryController.text = '';
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

  //Update Activity Function
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _activityTitleController.text = documentSnapshot['title'];
      _activityDescriptionController.text = documentSnapshot['description'];
      _activityCategoryController.text = documentSnapshot['type'];
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
                  controller: _activityTitleController,
                  decoration: const InputDecoration(labelText: 'Activity Name'),
                ),
                TextField(
                  controller: _activityDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _activityCategoryController,
                  decoration: const InputDecoration(labelText: 'Activity Type'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String title = _activityTitleController.text;
                    final String description =
                        _activityDescriptionController.text;
                    final String type = _activityCategoryController.text;
                    final String id = documentSnapshot!.id;

                    await ActivityRepository()
                        .updateActivity(id, title, description, type);
                    _activityTitleController.text = '';
                    _activityDescriptionController.text = '';
                    _activityCategoryController.text = '';
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

//Delete Activity Function
  Future<void> _delete(String recipeId) async {
    await ActivityRepository().deleteactivity(recipeId);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Successfully Deleted')));
  }

  Future<void> dialogBox(String lessonId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Activity'),
            content:
                const Text('Are you sure you want to delete this activity?'),
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
          title: const Center(child: Text('Activities')),
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
              .collection('activty')
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
                      leading: Text(documentSnapshot['type']),
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
