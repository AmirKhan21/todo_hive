import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor/models/request_model.dart';
import 'package:my_tutor/screens/tutor_to_student_chat_screen.dart';

import '../../models/user_model.dart';
import '../../utils/utility.dart';

class RequestDetailScreen extends StatefulWidget {
  final RequestModel request;

  const RequestDetailScreen({Key? key, required this.request})
      : super(key: key);

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  UserModel? userModel;

  Future fetchAccount() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(widget.request.requestedBy);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.grey.withOpacity(0.2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tutor Required For',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Class: ${widget.request.studentClass}"),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Subjects: ${widget.request.studentSubjects}"),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Tutor Must be',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "${widget.request.tutorGender} with min ${widget.request.tutorQualification} Qualification"),
                  Text(
                      "Request Date: ${Utility.getHumanReadableDate(widget.request.requestDate)} "),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Required in: ${widget.request.city} City"),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("Tutoring Criteria"),
                  Visibility(
                      visible: widget.request.tutorAtHome,
                      child: const Text('Tutor Required at Home')),
                  Visibility(
                      visible: widget.request.onlineTutoring,
                      child: const Text('Tutor Required For Online Class')),
                  Visibility(
                      visible: widget.request.studentsCanVisitTutor,
                      child: const Text('Student can Visit Tutor Place')),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.grey.withOpacity(0.2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Requested By',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  userModel == null
                      ? const CircleAvatar()
                      : Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.green, width: 2),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(userModel!.profilePic))),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              userModel!.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                              onPressed: () {
                                // 1. get student id
                                // 2. get current tutor id
                                // 3. create chat id
                                // 4. navigate to chat screen

                                // peer is the student with whom the current
                                // logged in tutor will chat

                                // here peerId is student id
                                String peerId = widget.request.requestedBy;

                                // here currentUserId is tutor id

                                // tutor will send message to student
                                String currentUserId =
                                    FirebaseAuth.instance.currentUser!.uid;
                                String chatGroupId = Utility.getChatGroupId(
                                    currentUserId, peerId);

                                print(chatGroupId);

                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                  return TutorToStudentChatScreen(currentUserId: currentUserId, peerId: peerId, chatGroupId: chatGroupId);
                                }));
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text('MESSAGE'),
                              ),
                            ),
                          ],
                        )
                  // ListTile(
                  //   leading: CircleAvatar(
                  //     backgroundImage: NetworkImage(userModel!.profilePic),
                  //   ),
                  //   title: Text(userModel!.name),
                  //   subtitle: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(20),
                  //           )),
                  //       onPressed: () {},
                  //       child: const Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 20.0),
                  //         child: Text('MESSAGE'),
                  //       )),
                  //
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
