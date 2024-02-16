
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_practice/ui/auth/login_screen.dart';

class SplashServices{

  void isLogin(BuildContext context){

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInScreen()));
    });

  }

}