import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor/screens/student_to_tutor_chat_screen.dart';

import '../../models/chat_box_model.dart';

class StudentChatBoxScreen extends StatefulWidget {
  const StudentChatBoxScreen({Key? key}) : super(key: key);

  @override
  State<StudentChatBoxScreen> createState() => _StudentChatBoxScreenState();
}

class _StudentChatBoxScreenState extends State<StudentChatBoxScreen> {
  List<ChatBoxModel> chats = [];
  bool chatsAvailable = false;

  Future<void> getChats() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    DatabaseReference chatsRef = FirebaseDatabase.instance.ref('chats');

    DatabaseEvent dbEvent = await chatsRef.once();

    var snapshots = dbEvent.snapshot.value;

    if (snapshots == null) {
      chatsAvailable = false;
      setState(() {});
    } else {
      Map<String, dynamic> map = Map<String, dynamic>.from(snapshots as Map);

      for (var entry in map.entries) {
        if (entry.key.contains(currentUserId)) {
          print('*********** ${entry.key}');

          // get the last message in chat

          Map<String, dynamic> map =
              Map<String, dynamic>.from(entry.value as Map);

          var finalMap = map.entries.last;

          final lastMessage = finalMap.value['message'];
          print(lastMessage);

          // extract lastMessage, peerId, peerProfilePic

          String chatId = entry.key;

          String peerId = '';
          if (finalMap.value['idFrom'] == currentUserId) {
            peerId = finalMap.value['idTo'];
          } else {
            peerId = finalMap.value['idFrom'];
          }

          DatabaseReference profilePicRef = FirebaseDatabase.instance
              .ref('users')
              .child(peerId)
              .child('profilePic');
          DatabaseEvent event = await profilePicRef.once();

          String peerProfilePic = event.snapshot.value.toString();
          print(peerProfilePic);
          print(peerId);

          DatabaseReference nameRef = FirebaseDatabase.instance
              .ref('users')
              .child(peerId)
              .child('name');
          DatabaseEvent event2 = await nameRef.once();

          String peerName = event2.snapshot.value.toString();

          ChatBoxModel chatBoxModel = ChatBoxModel(
              currentUserId: currentUserId,
              peerId: peerId,
              chatId: chatId,
              peerName: peerName,
              peerProfilePic: peerProfilePic,
              lastMessage: lastMessage);
          chats.add(chatBoxModel);
        }
      }

      chatsAvailable = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: chatsAvailable == false
          ? const Center(child: CircularProgressIndicator())
          : chats.isEmpty
              ? const Center(
                  child: Text('No Chats yet'),
                )
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        ChatBoxModel chatBoxModel = chats[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              chatBoxModel.peerProfilePic,
                            ),
                          ),
                          title: Text(chatBoxModel.peerName),
                          subtitle: Text(chatBoxModel.lastMessage),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return StudentToTutorChatScreen(
                                  currentUserId: chatBoxModel.currentUserId,
                                  peerId: chatBoxModel.peerId,
                                  chatGroupId: chatBoxModel.chatId);
                            }));
                          },
                        );
                      }),
                ),
    );
  }
}
