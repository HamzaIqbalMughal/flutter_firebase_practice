import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../auth/login_screen.dart';
import '../posts/add_post_screen.dart';

class FireStoreScreenList extends StatefulWidget {
  const FireStoreScreenList({super.key});

  @override
  State<FireStoreScreenList> createState() => _FireStoreScreenListState();
}

class _FireStoreScreenListState extends State<FireStoreScreenList> {

  final auth = FirebaseAuth.instance;

  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  bool searchedItemNotFound = false;
  int matchedItemcount = 0;

  @override
  void initState() {
    // TODO: implement initState
    // firebasePostRef.onValue.listen((event) { });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Post from FireStore'),
        actions: [
          const Text('Log out'),
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogInScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: Icon(Icons.logout_outlined))
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                  hintText: 'Search in list below',
                  border: OutlineInputBorder()),
              onChanged: (value) {
                setState(() {
                  searchedItemNotFound = false;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text('vcvbcvb'),
                  );
                }
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(
                  hintText: 'Edit here'
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);

                },
                child: Text('Update')
            ),
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text('Cancel')
            ),
          ],
        );
      },
    );
  }


}