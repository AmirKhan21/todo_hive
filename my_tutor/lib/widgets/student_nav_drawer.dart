import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor/screens/account_screen.dart';
import 'package:my_tutor/screens/landing_screen.dart';
import 'package:my_tutor/screens/student/student_chat_box_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

import '../models/user_model.dart';

class StudentNavDrawer extends StatefulWidget {
  const StudentNavDrawer({Key? key}) : super(key: key);

  @override
  State<StudentNavDrawer> createState() => _StudentNavDrawerState();
}

class _StudentNavDrawerState extends State<StudentNavDrawer> {
  UserModel? userModel;

  Future fetchAccount() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(uid);
    DatabaseEvent event = await userRef.once();
    DataSnapshot snapshot = event.snapshot;

    userModel =
        UserModel.fromMap(Map<String, dynamic>.from(snapshot.value as Map));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              padding: EdgeInsets.zero,
              child: userModel == null
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : Container(
                color: Colors.green,
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                      NetworkImage(userModel!.profilePic),
                      radius: 40,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(userModel!.name, style: const TextStyle(color: Colors.white)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(userModel!.email, style: const TextStyle(color: Colors.white))
                  ],
                ),
              )),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Account',
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const AccountScreen();
              }));
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.favorite),
          //   title: const Text(
          //     'Favourites',
          //   ),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text(
              'Messages',
            ),
            onTap: () {

              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const StudentChatBoxScreen();
              }));

            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text(
              'Share this App',
            ),
            onTap: () {
              Navigator.of(context).pop();
              // Share.share(
              //     'install the app https://play.google.com/store/apps/details?id=com.bucks.my_tutor',
              //     subject: 'My Tutor');
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_rate_outlined),
            title: const Text(
              'Rate this App',
            ),
            onTap: () {
              Navigator.of(context).pop();

              StoreRedirect.redirect();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Logout',
            ),
            onTap: () async{
              FirebaseAuth.instance.signOut();
              SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
              await sharedPrefs.clear();

              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return const LandingScreen();
              }));
            },
          ),
        ],
      ),
    );
  }
}
