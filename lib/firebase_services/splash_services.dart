
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_practice/ui/auth/login_screen.dart';
import 'package:flutter_firebase_practice/ui/firestore/firestore_screen_list.dart';
import 'package:flutter_firebase_practice/ui/posts/post_screen.dart';

class SplashServices{

  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if(user != null){
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FireStoreScreenList()));
      });
    }
    /*
    if(user != null){
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PostScreen()));
      });
    }
     */
    else{
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInScreen()));
      });
    }

  }

}