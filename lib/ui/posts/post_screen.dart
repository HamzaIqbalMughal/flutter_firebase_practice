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
        title: const Text('Post Screen'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
        },
        child: Icon(Icons.add),
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
          const Divider(
            height: 15,
            thickness: 5,
            color: Colors.red,
          ),
          const Text(
            'Below data fetched using StreamBuilder',
          ),
          const Divider(
            height: 15,
            thickness: 5,
            color: Colors.red,
          ),
          Expanded(
            child: StreamBuilder(
              stream: firebasePostRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.data != null &&
                    snapshot.data!.snapshot.value is Map<dynamic, dynamic>) {
                  Map<dynamic, dynamic> map =
                      snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  list = map.values.toList();
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    if (searchedItemNotFound) {
                      return Center(
                        child: Text('Not Found'),
                      );
                    } else {
                      matchedItemcount = 0;
                      searchedItemNotFound = false;
                      return ListView.builder(
                        itemCount: snapshot.data!.snapshot.children.length,
                        itemBuilder: (context, index) {
                          if (searchFilter.text.isEmpty) {
                            return ListTile(
                              title: Text(list[index]['title'].toString()),
                              subtitle: Text(list[index]['id'].toString()),
                              trailing: PopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                      onTap: (){
                                        Navigator.pop(context);
                                        showMyDialog(list[index]['title'].toString(), list[index]['id'].toString());
                                      },
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: (){
                                        firebasePostRef.child(list[index]['id'].toString()).remove();
                                        Navigator.pop(context);
                                        Utils().toastMessage(list[index]['title'].toString()+": is deleted");
                                      },
                                      leading: Icon(Icons.delete_outline),
                                      title: Text('Delete'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (list[index]['title']
                              .toString()
                              .toLowerCase()
                              .contains(searchFilter.text.toLowerCase())) {
                            matchedItemcount++;
                            return ListTile(
                              title: Text(list[index]['title'].toString()),
                              subtitle: Text(list[index]['id'].toString()),
                              trailing: PopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: (){
                                        Navigator.pop(context);
                                        showMyDialog(list[index]['title'].toString(), list[index]['id'].toString());
                                      },
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: ListTile(
                                      onTap: (){
                                        firebasePostRef.child(list[index]['id'].toString()).remove();
                                        Navigator.pop(context);
                                        Utils().toastMessage(list[index]['title'].toString()+": is deleted");
                                      },
                                      leading: Icon(Icons.delete_outline),
                                      title: Text('Delete'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            if (matchedItemcount == 0 &&
                                index ==
                                    snapshot.data!.snapshot.children.length -
                                        1) {
                              searchedItemNotFound = true;
                            }
                            return Container();
                          }
                        },
                      );
                    }
                  }
                } else {
                  return Center(child: Text('No Any Posts yet'));
                }
              },
            ),
          ),
          const Divider(
            height: 15,
            thickness: 5,
            color: Colors.red,
          ),
          const Text(
            'Below data fetched using FirebaseAnimatedList',
          ),
          const Divider(
            height: 15,
            thickness: 5,
            color: Colors.red,
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: firebasePostRef,
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('title').value.toString();

                if (searchFilter.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              showMyDialog(title, snapshot.child('id').value.toString());
                            },
                            leading: Icon(Icons.edit),
                            title: Text('Edit'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            onTap: (){
                              firebasePostRef.child(snapshot.child('id').value.toString()).remove();
                              Navigator.pop(context);
                              Utils().toastMessage(snapshot.child('title').value.toString()+": is deleted");
                            },
                            leading: Icon(Icons.delete_outline),
                            title: Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (title
                    .toLowerCase()
                    .contains(searchFilter.text.toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              showMyDialog(title, snapshot.child('id').value.toString());
                            },
                            leading: Icon(Icons.edit),
                            title: Text('Edit'),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            onTap: (){
                              firebasePostRef.child(snapshot.child('id').value.toString()).remove();
                              Navigator.pop(context);
                              Utils().toastMessage(snapshot.child('title').value.toString()+": is deleted");
                            },
                            leading: Icon(Icons.delete_outline),
                            title: Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
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
                  firebasePostRef.child(id).update({
                    'title': editController.text.toString()
                  }).then((value) {
                    Utils().toastMessage('Post Updated');
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
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
