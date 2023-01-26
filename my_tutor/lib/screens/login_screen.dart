import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tutor/screens/forgot_password_screen.dart';
import 'package:my_tutor/screens/sign_up_screen.dart';
import 'package:my_tutor/screens/student/student_home_screen.dart';
import 'package:my_tutor/screens/teacher/teacher_home_screen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../utils/network_connection.dart';

class LoginScreen extends StatefulWidget {
  final String userType;

  const LoginScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Account'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    hintText: 'Enter Email',
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                    hintText: 'Enter Password',
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {

                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return const ForgotPasswordScreen();
                    }));
                  },
                  child: const Text('Forgot Password ?', style: TextStyle(fontSize: 13),),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();

                    if (email.isEmpty) {
                      Fluttertoast.showToast(msg: 'Please provide Email');
                      return;
                    }

                    if (password.isEmpty) {
                      Fluttertoast.showToast(msg: 'Please provide Password');
                      return;
                    }

                    if (await NetworkConnection.isNotConnected()) {
                      Fluttertoast.showToast(
                          msg:
                              'You are Offline\nConnect to Internet and try again');
                      return;
                    }
                    // request to firebase auth

                    ProgressDialog progressDialog = ProgressDialog(
                      context,
                      title: const Text('Logging In'),
                      message: const Text('Please wait'),
                    );

                    progressDialog.show();

                    try {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      UserCredential userCredential =
                          await auth.signInWithEmailAndPassword(
                              email: email, password: password);

                      if (userCredential.user != null) {
                        // check user type
                        DatabaseReference userRef =
                            FirebaseDatabase.instance.ref().child('users');
                        String uid = userCredential.user!.uid;

                        DatabaseEvent event = await userRef.child(uid).once();
                        DataSnapshot snapshot = event.snapshot;

                        Map<String, dynamic> map =
                            Map<String, dynamic>.from(snapshot.value as Map);
                        print(map['userType']);
                        progressDialog.dismiss();



                        if (map['userType'] == widget.userType) {
                          print(map['userType']);


                          SharedPreferences sharedPrefs =
                          await SharedPreferences.getInstance();
                          sharedPrefs.setString(
                              Constants.userType, widget.userType);

                          if (widget.userType == Constants.teacher) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return const TeacherHomeScreen();
                            }));
                          } else {
                            print(map['userType']);

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return const StudentHomeScreen();
                            }));
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  'You are not registered as ${widget.userType}');
                        }
                      }
                    } on FirebaseAuthException catch (e) {
                      progressDialog.dismiss();

                      if (e.code == 'user-not-found') {
                        Fluttertoast.showToast(msg: 'User not found');
                      } else if (e.code == 'wrong-password') {
                        Fluttertoast.showToast(msg: 'Wrong password');
                      }
                    } catch (e) {
                      Fluttertoast.showToast(msg: 'Something went wrong');
                      print(e.toString());
                      progressDialog.dismiss();
                    }
                  },
                  child: const Text('Login Account')),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return SignUpScreen(userType: widget.userType);
                        }));
                      },
                      child: const Text(' Create One'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
