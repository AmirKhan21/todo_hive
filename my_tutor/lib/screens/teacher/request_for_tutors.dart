import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_tutor/models/request_model.dart';
import 'package:my_tutor/screens/teacher/request_detail_screen.dart';

import '../../utils/utility.dart';

class RequestForTutors extends StatefulWidget {
  const RequestForTutors({Key? key}) : super(key: key);

  @override
  State<RequestForTutors> createState() => _RequestForTutorsState();
}

class _RequestForTutorsState extends State<RequestForTutors> {
  DatabaseReference requestsRef =
      FirebaseDatabase.instance.ref().child('requests_for_tutors');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: requestsRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var event = snapshot.data as DatabaseEvent;

          var snapshot2 = event.snapshot.value;
          if (snapshot2 == null) {
            return const Center(
              child: Text("No Requests Found"),
            );
          }

          Map<String, dynamic> map =
              Map<String, dynamic>.from(snapshot2 as Map);
          var requests = <RequestModel>[];

          for (var requestMap in map.values) {
            RequestModel request =
                RequestModel.fromMap(Map<String, dynamic>.from(requestMap));

            requests.add(request);
          }

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  RequestModel request = requests[index];
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(bottom: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.grey.withOpacity(0.2)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tutor Required For', style: TextStyle(fontWeight: FontWeight.bold),),
                        const SizedBox(height: 5,),
                        Text("Class: ${request.studentClass}"),
                        const SizedBox(height: 5,),
                        Text("Subjects: ${request.studentSubjects}"),
                        const SizedBox(height: 5,),
                        Text("City: ${request.city}"),
                        const SizedBox(height: 10,),
                        const Text('Tutor Must be', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${request.tutorGender} with min ${request.tutorQualification} Qualification"),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date: ${Utility.getHumanReadableDate(request.requestDate)} "),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0)
                                  )
                                ),
                                onPressed: (){

                                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                    return RequestDetailScreen(request: request);
                                  }));
                                }, child: const Text("Read More"))
                          ],
                        )
                      ],
                    ),
                  );
                }),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }


}
