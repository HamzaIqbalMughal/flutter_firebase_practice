import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_practice/utils/utils.dart';
import 'package:flutter_firebase_practice/widgets/round_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('post');  // this will create a document named post


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text('Add Post'),
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
                  hintText: 'What is in your mind',
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
                setState(() {
                  loading = true;
                });
                databaseRef.child(DateTime.now().millisecondsSinceEpoch.toString()).child('Comment').set({
                  'title' : postController.text.toString(),
                  'id' : DateTime.now().millisecondsSinceEpoch.toString()
                }).then((value){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage('Post Added');
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
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
