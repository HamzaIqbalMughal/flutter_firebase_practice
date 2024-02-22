import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_practice/ui/auth/login_screen.dart';
import 'package:flutter_firebase_practice/utils/utils.dart';

import 'add_post_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final auth = FirebaseAuth.instance;

  final firebasePostRef = FirebaseDatabase.instance.ref('post');

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
        title: Text('Post Screen'),
        actions: [
          Text('Log out'),
          IconButton(onPressed: (){
            auth.signOut().then((value) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LogInScreen()));
            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });
          }, icon: Icon(Icons.logout_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPostScreen()));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          const Divider(
            height: 20,
            thickness: 10,
            color: Colors.red,
          ),
          const Text('Below data fetched using StreamBuilder',),
          const Divider(
            height: 20,
            thickness: 10,
            color: Colors.red,
          ),

          Expanded(
              child: StreamBuilder(
                  stream: firebasePostRef.onValue,
                  builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
                    Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                    List<dynamic> list = [];
                    list.clear();
                    list = map.values.toList();
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    }else{
                      return ListView.builder(
                          itemCount: snapshot.data!.snapshot.children.length,
                          itemBuilder: (context, index){
                            return ListTile(
                              title: Text(list[index]['title'].toString()),
                              subtitle: Text(list[index]['id'].toString()),
                            );
                          }
                      );
                    }
                  }
              ),
          ),


          const Divider(
            height: 20,
            thickness: 10,
            color: Colors.red,
          ),
          const Text('Below data fetched using FirebaseAnimatedList',),
          const Divider(
            height: 20,
            thickness: 10,
            color: Colors.red,
          ),
          Expanded(
            child: FirebaseAnimatedList(
                query: firebasePostRef, 
                itemBuilder: (context, snapshot, animation, index){
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                },
            ),
          ),
          
        ],
      ),
    );
  }
}
