import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tutor/screens/account_screen.dart';
import 'package:my_tutor/screens/teacher/tutor_location_screen.dart';
import 'package:my_tutor/screens/teacher/tutor_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

import '../models/user_model.dart';
import '../screens/landing_screen.dart';

class TutorNavDrawer extends StatefulWidget {
  const TutorNavDrawer({Key? key}) : super(key: key);

  @override
  State<TutorNavDrawer> createState() => _TutorNavDrawerState();
}

class _TutorNavDrawerState extends State<TutorNavDrawer> {
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
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text(
              'Tutor Profile',
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const TutorProfileScreen();
              }));
            },
          ),

          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text(
              'My Location',
            ),
            onTap: () {
              Navigator.of(context).pop();

              if( userModel == null ){
                Fluttertoast.showToast(msg: 'Please wait, try again later');
                return;
              }

              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return  TutorLocationScreen(tutorModel: userModel!);
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.message),
            title: const Text(
              'Messages',
            ),
            onTap: () {},
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
            onTap: () {
              showDialog(context: context, builder: (BuildContext context){
                return AlertDialog(
                  title: Text('Logout'),
                  content: Text("Are you sure you want to log out"),
                  actions: [
                    TextButton(onPressed: () async{
                      FirebaseAuth.instance.signOut();

                      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
                      await sharedPrefs.clear();

                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (context) {
                        return const LandingScreen();
                      }));
                    }, child: Text('Yes')),
                    TextButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text('No')),
                  ],
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
