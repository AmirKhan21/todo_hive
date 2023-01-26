import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tutor/screens/student/student_home_screen.dart';
import 'package:my_tutor/screens/teacher/teacher_home_screen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';
import '../utils/network_connection.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  final String userType;

  const SignUpScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _codeController;
  late TextEditingController _numberController;
  late TextEditingController _passwordController;
  late TextEditingController _retypeController;

  String city = 'Abbottabad';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _codeController = TextEditingController();
    _numberController = TextEditingController();
    _passwordController = TextEditingController();
    _retypeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _numberController.dispose();
    _passwordController.dispose();
    _retypeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    hintText: 'Enter Name',
                    labelText: 'Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
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
              Container(
                padding: const EdgeInsets.only(left: 10.0, top: 10, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.location_city,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('City'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: DropdownButton<String>(
                          isExpanded: true,
                          focusColor: Colors.white10,
                          value: city,
                          underline: const SizedBox.shrink(),
                          items: Constants.cities.map((e) {
                            return DropdownMenuItem<String>(
                              child: Text(e),
                              value: e,
                            );
                          }).toList(),
                          onChanged: (selectedCity) {
                            setState(() {
                              city = selectedCity!;
                            });
                          }),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.phone_android,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Mobile'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 40,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _codeController,
                              maxLength: 4,
                              decoration: const InputDecoration(
                                  hintText: 'Code',
                                  contentPadding: EdgeInsets.zero,
                                  counterText: '',
                                  border: InputBorder.none),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _numberController,
                              maxLength: 7,
                              decoration: const InputDecoration(
                                  hintText: 'Number',
                                  counterText: '',
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
              const SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                controller: _retypeController,
                decoration: InputDecoration(
                    hintText: 'Retype Password',
                    labelText: 'Retype Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (await NetworkConnection.isNotConnected()) {
                      Fluttertoast.showToast(
                          msg:
                              'You are Offline\nConnect to Internet and try again');
                      return;
                    }

                    if (validated()) {
                      // sign up using firebase auth

                      ProgressDialog progressDialog = ProgressDialog(
                        context,
                        title: const Text('Signing Up'),
                        message: const Text('Please wait'),
                      );

                      progressDialog.show();
                      try {
                        FirebaseAuth auth = FirebaseAuth.instance;

                        UserCredential userCredential =
                            await auth.createUserWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim());

                        if (userCredential.user != null) {
                          // store user information in Realtime database

                          DatabaseReference userRef =
                              FirebaseDatabase.instance.ref().child('users');

                          String uid = userCredential.user!.uid;
                          int dt = DateTime.now().millisecondsSinceEpoch;

                          await userRef.child(uid).set({
                            'name': _nameController.text.trim(),
                            'email': _emailController.text.trim(),
                            'city': city,
                            'code': _codeController.text.trim(),
                            'number': _numberController.text.trim(),
                            'uid': uid,
                            'dt': dt,
                            'qualification': '',
                            'userType': widget.userType,
                            'profilePic': 'https://firebasestorage.googleapis.com/v0/b/my-tutor-e4190.appspot.com/o/profile_pics%2Fplaceholder.jpeg?alt=media&token=ea1c0140-2052-459f-aadf-275612f8adfd'
                          });

                          Fluttertoast.showToast(msg: 'Success\nAccount Created', backgroundColor: Colors.green);

                          SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
                          sharedPrefs.setString(Constants.userType, widget.userType);


                          //Navigator.of(context).pop();
                          progressDialog.dismiss();

                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                              if( widget.userType == Constants.student){
                                return const StudentHomeScreen();
                              }
                              else
                                {
                                  return const TeacherHomeScreen();
                                }
                          }));
                        } else {
                          Fluttertoast.showToast(msg: 'Failed');
                          progressDialog.dismiss();
                        }
                      } on FirebaseAuthException catch (e) {
                        progressDialog.dismiss();
                        if (e.code == 'email-already-in-use') {
                          Fluttertoast.showToast(
                              msg: 'Email is already in Use');
                        } else if (e.code == 'weak-password') {
                          Fluttertoast.showToast(msg: 'Password is weak');
                        }
                      } catch (e) {
                        progressDialog.dismiss();
                        Fluttertoast.showToast(msg: 'Something went wrong');
                      }
                    }
                  },
                  child: const Text('Create Account')),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return LoginScreen(userType: widget.userType);
                        }));
                      },
                      child: const Text(' Login now'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  bool validated() {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String code = _codeController.text.trim();
    String number = _numberController.text.trim();
    String password = _passwordController.text;
    String rePassword = _retypeController.text;

    if (name.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide name', backgroundColor: Colors.red);
      return false;
    }
    if (email.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide email', backgroundColor: Colors.red);
      return false;
    }

    if( !EmailValidator.validate(email)){
      Fluttertoast.showToast(
          msg: 'Invalid Email Address', backgroundColor: Colors.red);
      return false;
    }

    if (code.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide code', backgroundColor: Colors.red);
      return false;
    }
    if (number.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide number', backgroundColor: Colors.red);
      return false;
    }
    if (password.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide password', backgroundColor: Colors.red);
      return false;
    }
    if (rePassword.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please retype password', backgroundColor: Colors.red);
      return false;
    }

    if (code.length < 4) {
      Fluttertoast.showToast(
          msg: 'Invalid Code, try again', backgroundColor: Colors.red);
      return false;
    }
    if (number.length < 7) {
      Fluttertoast.showToast(
          msg: 'Invalid number, try again', backgroundColor: Colors.red);
      return false;
    }
    if (password.length < 6) {
      Fluttertoast.showToast(
          msg: 'Invalid number, try again', backgroundColor: Colors.red);
      return false;
    }

    if (password != rePassword) {
      Fluttertoast.showToast(
          msg: 'Passwords do not match, try again',
          backgroundColor: Colors.red);
      return false;
    }

    return true;
  }
}
