import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tutor/models/user_model.dart';
import 'package:ndialog/ndialog.dart';

import '../utils/constants.dart';
import '../utils/network_connection.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _codeController;
  late TextEditingController _numberController;

  String city = 'Abbottabad';

  // placeholder image
  String existingImageUrl = "https://firebasestorage.googleapis.com/v0/b/my-tutor-e4190.appspot.com/o/profile_pics%2Fplaceholder.jpeg?alt=media&token=ea1c0140-2052-459f-aadf-275612f8adfd";
  File? imageFile;
  bool showLocalFile = false;

  Future fetchAccount() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(uid);
    DatabaseEvent event = await userRef.once();
    DataSnapshot snapshot = event.snapshot;

    UserModel userModel =
        UserModel.fromMap(Map<String, dynamic>.from(snapshot.value as Map));
    _nameController.text = userModel.name;
    _emailController.text = userModel.email;
    _codeController.text = userModel.code;
    _numberController.text = userModel.number;
    city = userModel.city;
    existingImageUrl = userModel.profilePic;
    setState(() {});
  }

  _pickImageFrom(ImageSource source) async {
    XFile? xFile = await ImagePicker().pickImage(source: source);

    if (xFile == null) return;

    final tempImage = File(xFile.path);

    imageFile = tempImage;
    showLocalFile = true;
    setState(() {});

    // upload to firebase storage

    ProgressDialog progressDialog = ProgressDialog(
      context,
      title: const Text('Uploading !!!'),
      message: const Text('Please wait'),
    );
    progressDialog.show();
    try {
      var fileName = FirebaseAuth.instance.currentUser!.email! + '.jpg';

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('profile_pics')
          .child(fileName)
          .putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;

      String profileImageUrl = await snapshot.ref.getDownloadURL();

      print(profileImageUrl);

      // update realtime database
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users').child(uid);
      await userRef.update({'profilePic': profileImageUrl});

      progressDialog.dismiss();
      Fluttertoast.showToast(
          msg: 'Profile Image Updated', backgroundColor: Colors.green);
    } catch (e) {
      progressDialog.dismiss();

      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _codeController = TextEditingController();
    _numberController = TextEditingController();

    fetchAccount();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: showLocalFile ?
                        FileImage(imageFile!) as ImageProvider
                        : NetworkImage(existingImageUrl),
                    radius: 80,
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('From Camera'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    _pickImageFrom(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image),
                                  title: const Text('From Gallery'),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    _pickImageFrom(ImageSource.gallery);

                                  },
                                ),
                              ],
                            );
                          });
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
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
                enabled: false,
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

                      // update account
                      String uid = FirebaseAuth.instance.currentUser!.uid;
                      DatabaseReference userRef = FirebaseDatabase.instance
                          .ref()
                          .child('users')
                          .child(uid);

                      await userRef.update({
                        'name': _nameController.text.trim(),
                        'city': city,
                        'code': _codeController.text.trim(),
                        'number': _numberController.text.trim(),
                      });

                      progressDialog.dismiss();
                      Fluttertoast.showToast(
                          msg: 'Account Updated',
                          backgroundColor: Colors.green);
                    }
                  },
                  child: const Text('Update Account')),
              const SizedBox(
                height: 20,
              ),
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

    return true;
  }
}
