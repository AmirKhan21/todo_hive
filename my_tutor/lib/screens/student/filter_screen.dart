import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_tutor/models/tutor_profile_model.dart';
import 'package:my_tutor/screens/student/tutor_detail_screen.dart';

import '../../utils/constants.dart';

class FilterScreen extends StatefulWidget {
  final String column, value;

  const FilterScreen({Key? key, required this.column, required this.value})
      : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List<TutorProfileModel> tutors = [];
  bool loading = false;

  String level = 'Preschool';
  String city = 'Abbottabad';

  Future filterTutors({required String column, required String value}) async {
    print(value);
    print('*********************************');
    loading = true;
    DatabaseReference usersRef =
        FirebaseDatabase.instance.ref().child('tutor_profile');
    DatabaseEvent usersEvent = await usersRef.once();
    DataSnapshot usersSnapshot = usersEvent.snapshot;

    for (DataSnapshot tutorProfileSnapshot in usersSnapshot.children) {
      TutorProfileModel tutorProfileModel = TutorProfileModel.fromMap(
          Map<String, dynamic>.from(tutorProfileSnapshot.value as Map));

      if (tutorProfileModel.classes.contains(value) ||
          tutorProfileModel.subjects.contains(value) ||
          tutorProfileModel.city.contains(value) ||
          tutorProfileModel.skills.contains(value) ||
          value.contains(tutorProfileModel.classes) ||
          value.contains(tutorProfileModel.city)) {
        tutors.add(tutorProfileModel);
      }
    }
    loading = false;
    print(tutors.length);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    filterTutors(column: widget.column, value: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutors for ${widget.value}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (BuildContext context,
                      void Function(void Function()) setState) {
                    return SimpleDialog(
                      title: const Text(
                        'Apply Filters',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                      children: [
                        const Text('SELECT A LEVEL'),
                        DropdownButton<String>(
                            isExpanded: true,
                            focusColor: Colors.white10,
                            value: level,
                            items: Constants.classes.map((e) {
                              return DropdownMenuItem<String>(
                                child: Text(e),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (selectedClass) {
                              setState(() {
                                level = selectedClass!;
                              });
                            }),
                        const SizedBox(height: 15),
                        const Text('SELECT A CITY'),
                        DropdownButton<String>(
                            isExpanded: true,
                            focusColor: Colors.white10,
                            value: city,
                            items: Constants.cities.map((e) {
                              return DropdownMenuItem<String>(
                                child: Text(e),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (selectedCity) {
                              setState(() {
                                city = selectedCity!;
                              });
                            }),
                        const SizedBox(height: 15),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              filterTutors(column: '', value: '$level, $city');
                            },
                            child: const Text('FILTER RESULTS'))
                      ],
                    );
                  },
                );
              });
        },
        child: const Icon(Icons.filter_alt_outlined),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : tutors.isEmpty
              ? const Center(
                  child: Text('Not Found'),
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
                  },
                ),
    );
  }
}
