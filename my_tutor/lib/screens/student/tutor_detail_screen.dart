import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor/models/tutor_profile_model.dart';
import 'package:my_tutor/models/user_model.dart';
import 'package:my_tutor/screens/student_to_tutor_chat_screen.dart';

import '../../utils/utility.dart';

class TutorDetailScreen extends StatefulWidget {
  final TutorProfileModel tutorProfileModel;

  const TutorDetailScreen({Key? key, required this.tutorProfileModel}) : super(key: key);

  @override
  State<TutorDetailScreen> createState() => _TutorDetailScreenState();
}

class _TutorDetailScreenState extends State<TutorDetailScreen> {

  UserModel? userModel;

  Future fetchProfile() async {
    DatabaseReference tutorProfileRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(widget.tutorProfileModel.uid);

    DatabaseEvent event = await tutorProfileRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.exists) {
      print('exists');
      userModel = UserModel.fromMap(
          Map<String, dynamic>.from(snapshot.value as Map));

      setState(() {});
    } else {
      print('No');
    }
  }

  // Future handleFavorite() async {
  //
  //   String tutorUid = widget.tutorProfileModel.uid;
  //
  //   // current user ( student )
  //   String uid = FirebaseAuth.instance.currentUser!.uid;
  //
  //   DatabaseReference favRef = FirebaseDatabase.instance
  //       .ref()
  //       .child('favorites')
  //       .child(uid);
  //
  //
  //
  // }

  @override
  void initState() {
    super.initState();
    // fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tutorProfileModel.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(widget.tutorProfileModel.profilePic))),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.tutorProfileModel.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${widget.tutorProfileModel.qualification} | ${widget.tutorProfileModel.city}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                    onPressed: () {

                      // peer id is the tutor id
                      String peerId = widget.tutorProfileModel.uid;

                      // current user is student, who will send message to tutor
                      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

                      String chatGroupId = Utility.getChatGroupId(
                          currentUserId, peerId);

                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return StudentToTutorChatScreen(currentUserId: currentUserId, peerId: peerId, chatGroupId: chatGroupId);
                      }));
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('MESSAGE'),
                    )),
                const SizedBox(
                  width: 20,
                ),
                // OutlinedButton(
                //   style: OutlinedButton.styleFrom(
                //     side: const BorderSide(
                //       color: Colors.green,
                //       width: 1,
                //       style: BorderStyle.solid,
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //   ),
                //   onPressed: () {
                //
                //
                //   },
                //   child: const Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 20.0),
                //     child: Text('FAVOURITE'),
                //   ),
                // ),
              ],
            ),
            const SizedBox(
                height: 30,
                child: Divider(
                  color: Colors.grey,
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.access_time_filled,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Availability',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(widget.tutorProfileModel.timing),
            const SizedBox(
                height: 30,
                child: Divider(
                  color: Colors.grey,
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.person_pin_rounded,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Introduction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(widget.tutorProfileModel.introduction),



            const SizedBox(
                height: 30,
                child: Divider(
                  color: Colors.grey,
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.business_center,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Teaching Experience',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
                widget.tutorProfileModel.experience),


            const SizedBox(
                height: 30,
                child: Divider(
                  color: Colors.grey,
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.money,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Fee',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text('Rs. ${widget.tutorProfileModel.fee}'),

            const SizedBox(
                height: 30,
                child: Divider(
                  color: Colors.grey,
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.document_scanner,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'I can Teach These Subjects',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(widget.tutorProfileModel.subjects),
            const SizedBox(
                height: 30,
                child: Divider(
                  color: Colors.grey,
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.book,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'I can Teach These Levels',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(widget.tutorProfileModel.classes),
            const SizedBox(
                height: 30,
                child: Divider(
                  color: Colors.grey,
                )),
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.format_align_justify,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Teaching Mode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text('[ ${getTeachingMode(widget.tutorProfileModel)} ]'),
          ],
        ),
      ),
    );
  }

  String getTeachingMode(TutorProfileModel tutorProfileModel) {
    String result = '';

    if (tutorProfileModel.iCanVisitStudent) {
      result = 'I can visit student home to teach,';
    }

    if (tutorProfileModel.studentCanVisitMe) {
      result += ' Students can visit me for tuition,';
    }

    if (tutorProfileModel.iCanTeachOnline) {
      result += ' I can teach online';
    }
    return result;
  }
}
