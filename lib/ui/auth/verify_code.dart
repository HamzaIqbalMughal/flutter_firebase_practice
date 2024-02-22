
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_practice/ui/posts/post_screen.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '6 digit code',
              ),
            ),
            SizedBox(
              height: 50,
            ),
            RoundButton(
                title: 'Verify',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  final credentials = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: verificationCodeController.text.toString(),
                  );
                  try{
                    await auth.signInWithCredential(credentials);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
                    setState(() {
                      loading = true;
                    });
                  }catch(e){
                    setState(() {
                      loading = true;
                    });
                    Utils().toastMessage(e.toString());
                  }
                },
            ),
          ],
        ),
      ),
    );
  }
}
