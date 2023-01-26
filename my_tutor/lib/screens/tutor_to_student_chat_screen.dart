import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_tutor/models/chat_model.dart';
import 'package:my_tutor/utils/utility.dart';

import '../models/user_model.dart';

class TutorToStudentChatScreen extends StatefulWidget {
  final String currentUserId; // tutor id
  final String peerId; // student id
  final String chatGroupId;

  const TutorToStudentChatScreen({
    Key? key,
    required this.currentUserId,
    required this.peerId,
    required this.chatGroupId,
  }) : super(key: key);

  @override
  State<TutorToStudentChatScreen> createState() =>
      _TutorToStudentChatScreenState();
}

class _TutorToStudentChatScreenState extends State<TutorToStudentChatScreen> {
  late TextEditingController txtController;
  DatabaseReference? chatRef;

  Future<UserModel> getPeerInfo() async {
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child('users').child(widget.peerId);
    DatabaseEvent event = await userRef.once();
    DataSnapshot snapshot = event.snapshot;

    UserModel userModel =
        UserModel.fromMap(Map<String, dynamic>.from(snapshot.value as Map));

    return userModel;
  }

  @override
  void initState() {
    super.initState();
    txtController = TextEditingController();
    chatRef = FirebaseDatabase.instance.ref('chats').child(widget.chatGroupId);
  }

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          title: FutureBuilder<UserModel>(
        future: getPeerInfo(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  snapshot.data!.profilePic,
                ),
              ),
              title: Text(
                snapshot.data!.name,
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else {
            return const Text('Loading...');
          }
        },
      ),),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: chatRef!.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var event = snapshot.data as DatabaseEvent;
                print(event.toString());

                var snapshot2 = event.snapshot.value;
                print(snapshot2.toString());

                if (snapshot2 == null) {
                  return const Center(
                    child: Text('Send your first message'),
                  );
                }

                Map<String, dynamic> map =
                    Map<String, dynamic>.from(snapshot2 as Map);

                List<ChatModel> chats = [];
                for (var jsonChat in map.values) {
                  ChatModel chatModel =
                      ChatModel.fromMap(Map<String, dynamic>.from(jsonChat));
                  chats.add(chatModel);
                }

                chats.sort((chat1, chat2) {
                  num time1 = num.parse(chat1.timestamp);
                  num time2 = num.parse(chat2.timestamp);

                  return time1.compareTo(time2);
                });

                return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      ChatModel chatModel = chats[index];

                      return Container(
                        alignment: chatModel.idFrom == widget.currentUserId
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        margin: chatModel.idFrom == widget.currentUserId
                            ? const EdgeInsets.only(
                                left: 100, bottom: 10, right: 10)
                            : const EdgeInsets.only(
                                right: 100, bottom: 10, left: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: chatModel.idFrom == widget.currentUserId
                                ? Colors.green[100]
                                : Colors.blue[100],
                            border: Border.all(color: Colors.white54),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(chatModel.message),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  Utility.getHumanReadableDate(
                                      num.parse(chatModel.timestamp)),
                                  style: TextStyle(
                                      fontSize: 10.0, color: Colors.grey[500]),
                                ))
                          ],
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
          Container(
            height: 50,
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: txtController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ))),
                IconButton(
                    onPressed: () {
                      String message = txtController.text.trim();
                      if (message.isEmpty) {
                        Fluttertoast.showToast(
                            msg: 'Please type a message',
                            backgroundColor: Colors.green);
                      } else {
                        String timestamp =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        chatRef!.child(timestamp).set({
                          'idFrom': widget.currentUserId,
                          'idTo': widget.peerId,
                          'timestamp': timestamp,
                          'message': message,
                        });

                        txtController.text = '';
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.green,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
