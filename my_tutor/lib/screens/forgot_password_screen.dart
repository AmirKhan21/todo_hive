import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

import '../utils/network_connection.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
               const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: Text('Receive an email to reset your password')),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    String email = _emailController.text.trim();

                    if (email.isEmpty) {
                      Fluttertoast.showToast(msg: 'Please provide Email');
                      return;
                    }

                    if (!EmailValidator.validate(email)) {
                      Fluttertoast.showToast(msg: 'Invalid Email');
                      return;
                    }

                    if (await NetworkConnection.isNotConnected()) {
                      Fluttertoast.showToast(
                          msg:
                              'You are Offline\nConnect to Internet and try again');
                      return;
                    }
                    ProgressDialog progressDialog = ProgressDialog(
                      context,
                      title: const Text('Sending'),
                      message: const Text('Please wait'),
                    );

                    progressDialog.show();

                    try{
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                      Fluttertoast.showToast(msg: 'Email Sent');
                      progressDialog.dismiss();

                    } on FirebaseAuthException catch(e){
                      progressDialog.dismiss();
                      Fluttertoast.showToast(msg: e.toString());

                    }


                  },
                  icon: const Icon(
                    Icons.email,
                    size: 20,
                  ),
                  label: const Text('Reset Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
