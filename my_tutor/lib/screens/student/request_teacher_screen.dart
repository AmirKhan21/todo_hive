import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:my_tutor/utils/constants.dart';
import 'package:ndialog/ndialog.dart';

class RequestTeacherScreen extends StatefulWidget {
  const RequestTeacherScreen({Key? key}) : super(key: key);

  @override
  State<RequestTeacherScreen> createState() => _RequestTeacherScreenState();
}

class _RequestTeacherScreenState extends State<RequestTeacherScreen> {
  String studentClass = "Preschool";
  String tutorQualification = "Masters";

  String gender = 'Male';
  List<String> selectedSubjects = [];
  late TextEditingController cityController;

  bool tutorAtHome = false;
  bool studentsCanVisitTutor = false;
  bool onlineTutoring = false;

  @override
  void initState() {
    super.initState();
    cityController = TextEditingController();
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request a Teacher"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "STUDENT IS STUDYING IN",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                  isExpanded: true,
                  value: studentClass,
                  items: Constants.classes.map((e) {
                    return DropdownMenuItem<String>(
                      child: Text(e),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      studentClass = value!;
                    });
                  }),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'TUTORING REQUIRED FOR THESE SUBJECTS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              MultiSelectDialogField<String>(
                title:
                    const Expanded(child: Text('subjects')),
                searchable: true,
                buttonIcon: const Icon(Icons.arrow_drop_down),
                buttonText: const Text(
                    'Select subjects for which tutoring is required'),
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
                '*Need a Tutor on Following Criteria',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "MINIMUM QUALIFICATION OF TUTOR",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                  isExpanded: true,
                  value: tutorQualification,
                  items: Constants.minQualification.map((e) {
                    return DropdownMenuItem<String>(
                      child: Text(e),
                      value: e,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      tutorQualification = value!;
                    });
                  }),
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
                'CITY',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: cityController,
                decoration:
                    const InputDecoration(hintText: "City Name"),
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
                        tutorAtHome = value!;
                      });
                    },
                    value: tutorAtHome,
                  ),
                  const Text('I want tutor at home'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    onChanged: (value) {
                      setState(() {
                        studentsCanVisitTutor = value!;
                      });
                    },
                    value: studentsCanVisitTutor,
                  ),
                  const Text('i can visit tutor\'s place for tuition'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    onChanged: (value) {
                      setState(() {
                        onlineTutoring = value!;
                      });
                    },
                    value: onlineTutoring,
                  ),
                  const Text('I want online tutoring'),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                  "*By clicking submit you understand that your information will be shared with relevant tutors"),
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
                        String requestedBy =
                            FirebaseAuth.instance.currentUser!.uid;
                        DatabaseReference tutorProfileRef = FirebaseDatabase
                            .instance
                            .ref()
                            .child('requests_for_tutors');

                        // convert list to string
                        String studentSubjects = selectedSubjects.join(',');

                        ProgressDialog progressDialog = ProgressDialog(
                          context,
                          title: const Text('Sending Request'),
                          message: const Text('Please wait'),
                        );

                        progressDialog.show();

                        await tutorProfileRef.push().set({
                          'requestedBy': requestedBy,
                          'studentClass': studentClass,
                          'studentSubjects': studentSubjects,
                          'tutorQualification': tutorQualification,
                          'tutorGender': gender,
                          'city': cityController.text.trim(),
                          'tutorAtHome': tutorAtHome,
                          'studentsCanVisitTutor': studentsCanVisitTutor,
                          'onlineTutoring': onlineTutoring,
                          'requestDate': DateTime.now().microsecondsSinceEpoch
                        });

                        progressDialog.dismiss();
                        Fluttertoast.showToast(
                            msg: 'Request Submitted',
                            backgroundColor: Colors.green);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'SUBMIT REQUEST',
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
    String city = cityController.text.trim();

    if (city.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide city', backgroundColor: Colors.red);
      return false;
    }

    if (selectedSubjects.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please select subject(s)', backgroundColor: Colors.red);
      return false;
    }

    if (selectedSubjects.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please select subject(s)', backgroundColor: Colors.red);
      return false;
    }

    if (tutorAtHome == false &&
        studentsCanVisitTutor == false &&
        onlineTutoring == false) {
      Fluttertoast.showToast(
          msg: 'Please select at least one tutoring options',
          backgroundColor: Colors.red);
      return false;
    }

    return true;
  }
}
