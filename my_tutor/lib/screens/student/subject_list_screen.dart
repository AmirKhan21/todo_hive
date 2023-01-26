import 'package:flutter/material.dart';
import 'package:my_tutor/screens/student/filter_screen.dart';

import '../../utils/constants.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({Key? key}) : super(key: key);

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Constants.subjects.length,
        itemBuilder: (context, index) {
          String subject = Constants.subjects[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(subject),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return FilterScreen(column: Constants.colSubject, value: subject);
                }));
              },
            ),
          );
        });
  }
}
