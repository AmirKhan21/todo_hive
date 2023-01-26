import 'package:flutter/material.dart';
import 'package:my_tutor/screens/student/cities_list_screen.dart';
import 'package:my_tutor/screens/student/classes_list_screen.dart';
import 'package:my_tutor/screens/student/skills_list_screen.dart';
import 'package:my_tutor/screens/student/student_dashboard.dart';
import 'package:my_tutor/screens/student/subject_list_screen.dart';
import 'package:my_tutor/widgets/student_nav_drawer.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({Key? key}) : super(key: key);

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 5,
      child: Builder(builder: (context) {
        return WillPopScope(
          onWillPop: () async {

            int? currentIndex = DefaultTabController.of(context)?.index;
            if( currentIndex != null && currentIndex == 0){
              return true;
            }else{
              DefaultTabController.of(context)?.animateTo(0);
              return false;
            }

          },
          child: Scaffold(
            drawer: const StudentNavDrawer(),
            appBar: AppBar(

              title: const Text('Welcome Student'),
              bottom: const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: 'Dashboard'),
                  Tab(text: 'Classes'),
                  Tab(text: 'Subjects'),
                  Tab(text: 'Cities'),
                  Tab(text: 'Skills'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                StudentDashboard(),
                ClassesListScreen(),
                SubjectListScreen(),
                CitiesListScreen(),
                SkillsListScreen(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
