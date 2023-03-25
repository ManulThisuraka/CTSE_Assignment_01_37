import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_lab03_inclass_01/repositories/lesson_repository.dart';
import 'package:ctse_lab03_inclass_01/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabMainOnePage extends StatefulWidget {
  final User? user;
  const TabMainOnePage({Key? key, this.animationController, this.user})
      : super(key: key);

  final AnimationController? animationController;
  @override
  State<TabMainOnePage> createState() => _TabMainOnePageState();
}

class _TabMainOnePageState extends State<TabMainOnePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _lessonTitleController = TextEditingController();
  final TextEditingController _lessonDescriptionController =
  TextEditingController();
  final TextEditingController _lessonSubmitController = TextEditingController();

  final uid = FirebaseAuth.instance.currentUser?.uid;

// Add Homework Function
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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                      controller: _lessonTitleController,
                      decoration: const InputDecoration(labelText: 'Book Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field can not be empty";
                        } else {
                          return null;
                        }
                      }),
                  TextFormField(
                      controller: _lessonDescriptionController,
                      decoration: const InputDecoration(labelText: 'Homework'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field can not be empty";
                        } else {
                          return null;
                        }
                      }),
                  TextFormField(
                      controller: _lessonSubmitController,
                      decoration:
                      const InputDecoration(labelText: 'Submission Date'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field can not be empty";
                        } else {
                          return null;
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Create'),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final String title = _lessonTitleController.text;
                        final String description =
                            _lessonDescriptionController.text;
                        final String submission = _lessonSubmitController.text;
                        await LessonRepository()
                            .addLesson(title, description, submission);

                        _lessonTitleController.text = '';
                        _lessonDescriptionController.text = '';
                        _lessonSubmitController.text = '';
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Successfully Added')));
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

//Update Homework Function
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _lessonTitleController.text = documentSnapshot['title'];
      _lessonDescriptionController.text = documentSnapshot['description'];
      _lessonSubmitController.text = documentSnapshot['submission'];
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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                      controller: _lessonTitleController,
                      decoration: const InputDecoration(labelText: 'Book Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field can not be empty";
                        } else {
                          return null;
                        }
                      }),
                  TextFormField(
                      controller: _lessonDescriptionController,
                      decoration: const InputDecoration(labelText: 'Homework'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field can not be empty";
                        } else {
                          return null;
                        }
                      }),
                  TextFormField(
                      controller: _lessonSubmitController,
                      decoration:
                      const InputDecoration(labelText: 'Submission Date'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field can not be empty";
                        } else {
                          return null;
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final String title = _lessonTitleController.text;
                        final String description =
                            _lessonDescriptionController.text;
                        final String submission = _lessonSubmitController.text;
                        final String id = documentSnapshot!.id;

                        await LessonRepository()
                            .updateLesson(id, title, description, submission);
                        _lessonTitleController.text = '';
                        _lessonDescriptionController.text = '';
                        _lessonSubmitController.text = '';
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Successfully Updated')));
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

//Delete Homework Function
  Future<void> _delete(String lessonId) async {
    await LessonRepository().deleteLesson(lessonId);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Successfully Deleted')));
  }

  Future<void> dialogBox(String lessonId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Homework'),
            content:
            const Text('Are you sure you want to delete this homework?'),
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
          title: const Center(child: Text('Homework')),
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
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    final navigator = Navigator.of(context);
                    await FirebaseAuth.instance.signOut();
                    navigator.pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Icon(Icons.logout),
                )),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('lessons')
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
                      leading: Text(documentSnapshot['submission']),
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
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 60.0),
            child: FloatingActionButton(
                onPressed: () => _create(widget.user!),
                child: const Icon(Icons.add))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
