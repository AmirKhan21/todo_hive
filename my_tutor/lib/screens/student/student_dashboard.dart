import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor/models/tutor_profile_model.dart';
import 'package:my_tutor/models/user_model.dart';
import 'package:my_tutor/screens/student/book_screen.dart';
import 'package:my_tutor/screens/student/request_teacher_screen.dart';
import 'package:my_tutor/screens/student/tutor_detail_screen.dart';
import 'package:my_tutor/screens/student/tutors_nearby_screen.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  List<TutorProfileModel> tutors = [];

  @override
  void initState() {
    super.initState();
    fetchTutorsByCity();
  }

  Future fetchTutorsByCity() async {
    String? currentUserCity;

    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference currentUserRef =
        FirebaseDatabase.instance.ref().child('users').child(uid);

    DatabaseEvent currentUserEvent = await currentUserRef.once();
    DataSnapshot currentUserSnapshot = currentUserEvent.snapshot;
    if (currentUserSnapshot.exists) {
      UserModel currentUser = UserModel.fromMap(
          Map<String, dynamic>.from(currentUserSnapshot.value as Map));
      print(currentUser.city);
      currentUserCity = currentUser.city;
    }

    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child('tutor_profile');
    DatabaseEvent usersEvent = await usersRef.once();
    DataSnapshot usersSnapshot = usersEvent.snapshot;

    for (DataSnapshot tutorProfileSnapshot in usersSnapshot.children) {
      TutorProfileModel tutorProfileModel = TutorProfileModel.fromMap(
          Map<String, dynamic>.from(tutorProfileSnapshot.value as Map));

      if (currentUserCity != null &&
          tutorProfileModel.city == currentUserCity) {
        tutors.add(tutorProfileModel);
      }
    }
    print(tutors.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 350,
          color: Colors.grey[200],
          child: Center(
            child: GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              children: [
                GestureDetector(
                  onTap: () {
                    DefaultTabController.of(context)?.animateTo(1);
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 30,
                          child: Icon(
                            Icons.adjust,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Tutors for\nyour Class',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    DefaultTabController.of(context)?.animateTo(2);
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 30,
                          child: Icon(
                            Icons.date_range,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Tutors by\nSubjects',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    DefaultTabController.of(context)?.animateTo(3);
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30,
                          child: Icon(
                            Icons.location_on,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'City Wise\nTutors',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    DefaultTabController.of(context)?.animateTo(4);
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.red[400],
                          radius: 30,
                          child: const Icon(
                            Icons.group,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Learn a skill',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const RequestTeacherScreen();
                    }));
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.purple[400],
                          radius: 30,
                          child: const Icon(
                            Icons.person_add,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Request a\nTutor',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const TutorsNearbyScreen();
                    }));
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.brown[400],
                          radius: 30,
                          child: const Icon(
                            Icons.gps_fixed,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Nearby Tutors',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return BookScreen();
                    }));
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          // backgroundColor: Colors.brown[400],
                          backgroundColor: Colors.pink,
                          radius: 30,
                          child: const Icon(
                            Icons.book,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Motivational\nBook',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recommended Tutors',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'MORE',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
        Expanded(
            child: tutors.isEmpty
                ? const Center(
                    child: Text('No Recommended Tutors'),
                  )
                : ListView.builder(
                    itemCount: tutors.length,
                    itemBuilder: (context, index) {
                      TutorProfileModel tutor = tutors[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return TutorDetailScreen(tutorProfileModel: tutor);
                          }));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(tutor.profilePic),
                          ),
                          title: Text(tutor.name),
                          subtitle: Text(tutor.qualification),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(tutor.city),
                              const Icon(
                                Icons.location_on,
                                color: Colors.green,
                              )
                            ],
                          ),
                        ),
                      );
                    })),
      ],
    );
  }
}
