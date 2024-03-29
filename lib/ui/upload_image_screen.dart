import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_practice/utils/utils.dart';
import 'package:flutter_firebase_practice/widgets/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'auth/login_screen.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {

  final auth = FirebaseAuth.instance;

  bool _loading = false;

  File? _image;
  final picker = ImagePicker();


  firebase_storage.FirebaseStorage storage_firebase = firebase_storage.FirebaseStorage.instance;

  final firebaseDatabase_ref = FirebaseDatabase.instance.ref('ImageUrl');


  Future getGalleryImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {

    });

    if(pickedFile != null){
      _image = File(pickedFile.path);
    }else{
      Utils().toastMessage('File is not picked');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Image Firebase'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: (){
                  getGalleryImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    )
                  ),
                  child: _image != null ? Image.file(_image!.absolute) : Center(child: Icon(Icons.image)),
                ),
              ),
            ),
            SizedBox(height: 30,),
            RoundButton(title: 'Upload',loading: _loading , onTap: () async {

              setState(() {
                _loading = true;
              });

              // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/folderName/'+'profilePic');

              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/profilesPics/'+DateTime.now().millisecondsSinceEpoch.toString());
              firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);
              Future.value(uploadTask).then((value) async {
                var newImgUrl = await ref.getDownloadURL();

                firebaseDatabase_ref.child('4').set({
                  'id': '444',
                  'title': newImgUrl.toString()
                }).then((value) {
                  setState(() {
                    _loading = false;
                  });
                  Utils().toastMessage('Image Uploaded');
                }).onError((error, stackTrace) {
                  setState(() {
                    _loading = false;
                  });
                });
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
                setState(() {
                  _loading = false;
                });
              });




            }),
          ],
        ),
      ),
    );
  }
}
