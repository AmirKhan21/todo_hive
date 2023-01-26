import 'package:flutter/material.dart';
import 'package:my_tutor/screens/teacher/chat_box_screen.dart';
import 'package:my_tutor/screens/teacher/request_for_tutors.dart';
import 'package:my_tutor/widgets/tutor_nav_drawer.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({Key? key}) : super(key: key);

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const TutorNavDrawer(),
        appBar: AppBar(
          title: const Text('Welcome Teacher'),
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text('Requests'),
              ),
              Tab(
                child: Text('Messages'),
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            RequestForTutors(),
            ChatBoxScreen(),
          ],
        ),
      ),
    );
  }
}
