import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_lab03_inclass_01/repositories/recipe_repository.dart';
import 'package:ctse_lab03_inclass_01/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TabMainFourPage extends StatefulWidget {
  final User? user;

  const TabMainFourPage({Key? key, this.animationController, this.user})
      : super(key: key);

  final AnimationController? animationController;

  @override
  State<TabMainFourPage> createState() => __TabMainFourPageState();
}

class __TabMainFourPageState extends State<TabMainFourPage> {
  final TextEditingController _recipeTitleController = TextEditingController();
  final TextEditingController _recipeDescriptionController =
      TextEditingController();

  // final CollectionReference _recipe =
  //     FirebaseFirestore.instance.collection('recipes');
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final formKey = GlobalKey<FormState>();

  final _picker = ImagePicker();
  XFile? _imageFile;

  void _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  // Create new recipe function
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
                      controller: _recipeTitleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field can not be empty";
                        } else {
                          return null;
                        }
                      }),
                  TextFormField(
                      controller: _recipeDescriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
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
                    child: const Text('Select Image'),
                    onPressed: _selectImage,
                  ),
                  ElevatedButton(
                    child: const Text('Create'),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final String title = _recipeTitleController.text;
                        final String description =
                            _recipeDescriptionController.text;

                        // Upload image to Firebase Storage
                        String? imageUrl;
                        if (_imageFile != null) {
                          final Reference storageRef = FirebaseStorage.instance
                              .ref()
                              .child(
                                  'images/${DateTime.now().millisecondsSinceEpoch}.jpg');
                          final TaskSnapshot snapshot =
                              await storageRef.putFile(File(_imageFile!.path));
                          imageUrl = await snapshot.ref.getDownloadURL();
                        }
                        await RecipeRepository()
                            .addRecipe(title, description, imageUrl!);

                        _recipeTitleController.text = '';
                        _recipeDescriptionController.text = '';
                        setState(() {
                          _imageFile = null;
                        });
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Update a recipe function
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _recipeTitleController.text = documentSnapshot['title'];
      _recipeDescriptionController.text = documentSnapshot['description'];
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
                  controller: _recipeTitleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _recipeDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String title = _recipeTitleController.text;
                    final String description =
                        _recipeDescriptionController.text;
                    final String id = documentSnapshot!.id;

                    await RecipeRepository()
                        .updateRecipe(id, title, description);
                    _recipeTitleController.text = '';
                    _recipeDescriptionController.text = '';
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> dialogBox(String recipeId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Recipe'),
            content: const Text('Are you sure you want to delete this recipe?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  _delete(recipeId);
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

  // Delete a recipe
  Future<void> _delete(String recipeId) async {
    await RecipeRepository().deleteRecipe(recipeId);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a recipe')));
  }

  Future<String> uploadImage(var imageFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("image1${DateTime.now()}");
    UploadTask uploadTask = ref.putFile(imageFile);
    final imageUrl = await uploadTask.then((res) {
      res.ref.getDownloadURL();
    });
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Children')),
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
              .collection('recipes')
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
                      leading: Image.network(
                        documentSnapshot['imageUrl'],
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
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
