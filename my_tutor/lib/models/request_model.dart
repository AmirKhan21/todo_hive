class RequestModel {
  late String requestedBy;
  late String studentClass;
  late String studentSubjects;
  late String tutorQualification;
  late String tutorGender;
  late String city;
  late bool tutorAtHome;
  late bool studentsCanVisitTutor;
  late bool onlineTutoring;
  late num requestDate;

  RequestModel({
    required this.requestedBy,
    required this.studentClass,
    required this.studentSubjects,
    required this.tutorQualification,
    required this.tutorGender,
    required this.city,
    required this.tutorAtHome,
    required this.studentsCanVisitTutor,
    required this.onlineTutoring,
    required this.requestDate
  });

  RequestModel.fromMap( Map<String, dynamic> map) {
    requestedBy = map['requestedBy'];
    studentClass = map['studentClass'];
    studentSubjects = map['studentSubjects'];
    tutorQualification = map['tutorQualification'];
    tutorGender = map['tutorGender'];
    city = map['city'];
    tutorAtHome= map['tutorAtHome'];
    studentsCanVisitTutor = map['studentsCanVisitTutor'];
    onlineTutoring= map['onlineTutoring'];
    requestDate = map['requestDate'];
  }
}


