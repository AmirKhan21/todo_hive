import 'package:flutter/material.dart';
import 'package:my_tutor/screens/student/filter_screen.dart';

import '../../utils/constants.dart';

class ClassesListScreen extends StatefulWidget {
  const ClassesListScreen({Key? key}) : super(key: key);

  @override
  State<ClassesListScreen> createState() => _ClassesListScreenState();
}

class _ClassesListScreenState extends State<ClassesListScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Constants.classes.length,
        itemBuilder: (context, index) {
          String cls = Constants.classes[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(cls),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return FilterScreen(column: Constants.colClass, value: cls);
                }));
              },
            ),
          );
        });
  }
}
