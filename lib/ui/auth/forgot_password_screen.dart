import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_practice/utils/utils.dart';
import 'package:flutter_firebase_practice/widgets/round_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final auth = FirebaseAuth.instance;
  bool _loading = false;

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password Screen'),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email'
              ),
            ),
            SizedBox(height: 40,),
            RoundButton(title: 'Forgot', loading: _loading, onTap: (){
              setState(() {
                _loading = true;
              });
              auth.sendPasswordResetEmail(
                  email: _emailController.text.toString(),
              ).then((value) {
                Utils().toastMessage('We have sent you email to recover password, plz check email');
                setState(() {
                  _loading = false;
                });
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
                setState(() {
                  _loading = false;
                });
              });
            })
          ],
        ),
      ),
    );
  }
}
