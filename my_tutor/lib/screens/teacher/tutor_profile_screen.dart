import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:my_tutor/models/tutor_profile_model.dart';
import 'package:my_tutor/models/user_model.dart';
import 'package:ndialog/ndialog.dart';
import '../../utils/constants.dart';

class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({Key? key}) : super(key: key);

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  UserModel? tutorModel;

  late TextEditingController qualificationController,
      introductionController,
      experienceController,
      timingController,
      feeController;

  String gender = 'Male';
  List<String> selectedSubjects = [];
  List<String> selectedClasses = [];
  List<String> selectedSkills = [];

  bool iCanVisitStudent = false;
  bool studentsCanVisitMe = false;
  bool iCanTeachOnline = false;

  Future getTutorBasicInfo() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference currentUserRef =
        FirebaseDatabase.instance.ref().child('users').child(uid);

    DatabaseEvent currentUserEvent = await currentUserRef.once();
    DataSnapshot currentUserSnapshot = currentUserEvent.snapshot;
    if (currentUserSnapshot.exists) {
      tutorModel = UserModel.fromMap(
          Map<String, dynamic>.from(currentUserSnapshot.value as Map));
    }
  }

  Future fetchProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference tutorProfileRef =
        FirebaseDatabase.instance.ref().child('tutor_profile').child(uid);

    DatabaseEvent event = await tutorProfileRef.once();
    DataSnapshot snapshot = event.snapshot;

    if (snapshot.exists) {
      print('exists');
      TutorProfileModel tutorProfileModel = TutorProfileModel.fromMap(
          Map<String, dynamic>.from(snapshot.value as Map));
      qualificationController.text = tutorProfileModel.qualification;
      introductionController.text = tutorProfileModel.introduction;
      experienceController.text = tutorProfileModel.experience;
      timingController.text = tutorProfileModel.timing;
      feeController.text = tutorProfileModel.fee;
      String strSubjects = tutorProfileModel.subjects;
      List<String> subjects = strSubjects.split(',');
      selectedSubjects = subjects;

      String strClasses = tutorProfileModel.classes;
      selectedClasses = strClasses.split(',');

      String strSkills = tutorProfileModel.skills;
      selectedSkills = strSkills.split(',');

      iCanVisitStudent = tutorProfileModel.iCanVisitStudent;
      studentsCanVisitMe = tutorProfileModel.studentCanVisitMe;
      iCanTeachOnline = tutorProfileModel.iCanTeachOnline;

      setState(() {});
    } else {
      print('No');
    }
  }

  @override
  void initState() {
    super.initState();
    qualificationController = TextEditingController();
    introductionController = TextEditingController();
    experienceController = TextEditingController();
    timingController = TextEditingController();
    feeController = TextEditingController();
    getTutorBasicInfo();
    fetchProfile();
  }

  @override
  void dispose() {
    super.dispose();
    qualificationController.dispose();
    introductionController.dispose();
    experienceController.dispose();
    timingController.dispose();
    feeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutor Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MY QUALIFICATION',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: qualificationController,
                decoration:
                    const InputDecoration(hintText: 'e.g BS Computer Science'),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'GENDER',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                  isExpanded: true,
                  value: gender,
                  items: <String>['Male', 'Female'].map((e) {
                    return DropdownMenuItem<String>(
                      child: Text(e),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  }),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'INTRODUCTION',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: introductionController,
                decoration: const InputDecoration(
                    hintText: 'Write something about yourself'),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'TEACHING EXPERIENCE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: experienceController,
                decoration: const InputDecoration(
                    hintText: 'Write about your teaching career'),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'TUTORING AVAILABILITY',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: timingController,
                decoration: const InputDecoration(
                    hintText: 'Describe your tutoring timings'),
              ),


              const SizedBox(
                height: 25,
              ),
              const Text(
                'FEE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: feeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Mention your fee'),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'I CAN TEACH THESE SUBJECTS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MultiSelectDialogField<String>(
                title:
                    const Expanded(child: Text('What subjects can you teach?')),
                searchable: true,
                buttonIcon: const Icon(Icons.arrow_drop_down),
                buttonText: const Text('What subjects can you teach?'),
                initialValue: selectedSubjects,
                items: Constants.subjects.map((subject) {
                  return MultiSelectItem(subject, subject);
                }).toList(),
                listType: MultiSelectListType.LIST,
                onConfirm: (values) {
                  selectedSubjects = values;
                  print(selectedSubjects.length);
                },
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'I CAN TEACH THESE CLASSES',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MultiSelectDialogField<String>(
                title:
                    const Expanded(child: Text('What levels can you teach?')),
                searchable: true,
                buttonIcon: const Icon(Icons.arrow_drop_down),
                buttonText: const Text('What levels can you teach?'),
                initialValue: selectedClasses,
                items: Constants.classes.map((cls) {
                  return MultiSelectItem(cls, cls);
                }).toList(),
                listType: MultiSelectListType.LIST,
                onConfirm: (values) {
                  selectedClasses = values;
                  print(selectedClasses.length);
                },
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'I CAN TEACH THESE SKILLS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MultiSelectDialogField<String>(
                title:
                    const Expanded(child: Text('What skills can you teach?')),
                searchable: true,
                buttonIcon: const Icon(Icons.arrow_drop_down),
                buttonText: const Text('What skills can you teach?'),
                initialValue: selectedSkills,
                items: Constants.skills.map((subject) {
                  return MultiSelectItem(subject, subject);
                }).toList(),
                listType: MultiSelectListType.LIST,
                onConfirm: (values) {
                  selectedSkills = values;
                  print(selectedSkills.length);
                },
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'TUTORING OPTIONS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Checkbox(
                    onChanged: (value) {
                      setState(() {
                        iCanVisitStudent = value!;
                      });
                    },
                    value: iCanVisitStudent,
                  ),
                  const Text('I can visit student home to teach'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    onChanged: (value) {
                      setState(() {
                        studentsCanVisitMe = value!;
                      });
                    },
                    value: studentsCanVisitMe,
                  ),
                  const Text('Students can visit me for tuition'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    onChanged: (value) {
                      setState(() {
                        iCanTeachOnline = value!;
                      });
                    },
                    value: iCanTeachOnline,
                  ),
                  const Text('I can teach online'),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        padding: const EdgeInsets.symmetric(vertical: 10)),
                    onPressed: () async {
                      if (validated()) {
                        String uid = FirebaseAuth.instance.currentUser!.uid;
                        DatabaseReference tutorProfileRef = FirebaseDatabase
                            .instance
                            .ref()
                            .child('tutor_profile')
                            .child(uid);

                        // convert list to string
                        String subjects = selectedSubjects.join(',');
                        String classes = selectedClasses.join(',');
                        String skills = selectedSkills.join(',');

                        ProgressDialog progressDialog = ProgressDialog(
                          context,
                          title: const Text('Updating Profile'),
                          message: const Text('Please wait'),
                        );

                        progressDialog.show();

                        await tutorProfileRef.set({
                          'uid': uid,
                          'qualification': qualificationController.text.trim(),
                          'gender': gender,
                          'introduction': introductionController.text.trim(),
                          'experience': experienceController.text.trim(),
                          'timing': timingController.text.trim(),
                          'fee': feeController.text.trim(),
                          'subjects': subjects,
                          'classes': classes,
                          'skills': skills,
                          'iCanVisitStudent': iCanVisitStudent,
                          'studentCanVisitMe': studentsCanVisitMe,
                          'iCanTeachOnline': iCanTeachOnline,
                          'name': tutorModel!.name,
                          'city': tutorModel!.city,
                          'profilePic': tutorModel!.profilePic
                        });

                        DatabaseReference userRef = FirebaseDatabase.instance
                            .ref()
                            .child('users')
                            .child(uid);
                        await userRef.update({
                          'qualification': qualificationController.text.trim()
                        });

                        progressDialog.dismiss();
                        Fluttertoast.showToast(
                            msg: 'Profile Updated',
                            backgroundColor: Colors.green);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'UPDATE  PROFILE',
                      style: TextStyle(fontSize: 18),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  bool validated() {
    String qualification = qualificationController.text.trim();
    String introduction = introductionController.text.trim();
    String experience = experienceController.text.trim();
    String timing = timingController.text.trim();
    String fee = feeController.text.trim();
    if (qualification.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide qualification', backgroundColor: Colors.red);
      return false;
    }

    if (introduction.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide introduction', backgroundColor: Colors.red);
      return false;
    }

    if (experience.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide experience', backgroundColor: Colors.red);
      return false;
    }

    if (timing.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide timing availability',
          backgroundColor: Colors.red);
      return false;
    }

    if (fee.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide fee charges',
          backgroundColor: Colors.red);
      return false;
    }

    if (selectedSubjects.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please select subject(s)', backgroundColor: Colors.red);
      return false;
    }

    if (selectedClasses.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please select class(es)', backgroundColor: Colors.red);
      return false;
    }
    if (selectedSkills.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please select skill(s)', backgroundColor: Colors.red);
      return false;
    }

    if (iCanVisitStudent == false &&
        studentsCanVisitMe == false &&
        iCanTeachOnline == false) {
      Fluttertoast.showToast(
          msg: 'Please select at least one tutoring options',
          backgroundColor: Colors.red);
      return false;
    }

    return true;
  }
}
