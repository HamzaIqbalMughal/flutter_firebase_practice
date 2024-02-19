import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_practice/ui/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_practice/utils/utils.dart';
import '../../widgets/round_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool loading = false;

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  void signUp(){
    if(passController.text.toString() == confirmPassController.text.toString()){
      setState(() {
        loading = true;
      });
      _auth.createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passController.text.toString()
      ).then((value) {
        setState(() {
          loading = false;
        });
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp Screen'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      helperText: 'enter email e.g: abc@xyz.com',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Enter Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: passController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Enter Password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: confirmPassController,
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Enter Password';
                      }
                      else if(value!.toString() != passController!.text!.toString()){
                        return 'Password does not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 50,),
            RoundButton(
              loading: loading,
              title: 'SignUp',
              onTap: () {
                if(_formKey.currentState!.validate()){
                  signUp();
                }
              },
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Text("Already have an Account? "),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LogInScreen()));
                }, child: Text('Log In'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
