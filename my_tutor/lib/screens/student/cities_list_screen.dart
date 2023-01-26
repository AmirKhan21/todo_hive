import 'package:flutter/material.dart';
import 'package:my_tutor/screens/student/filter_screen.dart';

import '../../utils/constants.dart';

class CitiesListScreen extends StatefulWidget {
  const CitiesListScreen({Key? key}) : super(key: key);

  @override
  State<CitiesListScreen> createState() => _CitiesListScreenState();
}

class _CitiesListScreenState extends State<CitiesListScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Constants.cities.length,
        itemBuilder: (context, index) {
          String city = Constants.cities[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(city),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return FilterScreen(column: Constants.colCity, value: city);
                }));

              },
            ),
          );
        });
  }
}
