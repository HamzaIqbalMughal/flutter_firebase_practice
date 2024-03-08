import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_practice/utils/utils.dart';

import '../../widgets/round_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFireStoreDataScreen extends StatefulWidget {
  const AddFireStoreDataScreen({super.key});

  @override
  State<AddFireStoreDataScreen> createState() => _AddFireStoreDataScreenState();
}

class _AddFireStoreDataScreenState extends State<AddFireStoreDataScreen> {
  final postController = TextEditingController();
  bool loading = false;

  final fireStore_users = FirebaseFirestore.instance.collection('users');
  final fireStore_persons = FirebaseFirestore.instance.collection('persons');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text('FireStore Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'What is in your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
              loading: loading,
              title: 'Add',
              onTap: () {
                String id = DateTime.now().millisecondsSinceEpoch.toString();
                setState(() {
                  loading = true;
                });

                /*
                fireStore_persons.doc(id).set({
                  'title' : postController.text.toString(),
                  'id' : id,
                }).then((value) {
                  Utils().toastMessage('Post Added to FireStore');
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
                */
                fireStore_users.doc(id).set({
                  'title' : postController.text.toString(),
                  'id' : id,
                }).then((value) {
                  Utils().toastMessage('Post Added to FireStore');
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
