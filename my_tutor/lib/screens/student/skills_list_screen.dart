import 'package:flutter/material.dart';
import 'package:my_tutor/screens/student/filter_screen.dart';

import '../../utils/constants.dart';

class SkillsListScreen extends StatefulWidget {
  const SkillsListScreen({Key? key}) : super(key: key);

  @override
  State<SkillsListScreen> createState() => _SkillsListScreenState();
}

class _SkillsListScreenState extends State<SkillsListScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Constants.skills.length,
        itemBuilder: (context, index) {
          String skill = Constants.skills[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(skill),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return FilterScreen(column: Constants.colSkill, value: skill);
                }));
              },
            ),
          );
        });
  }
}
