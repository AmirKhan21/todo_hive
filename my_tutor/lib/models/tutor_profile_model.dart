class TutorProfileModel {
  late String uid;
  late String qualification;
  late String gender;
  late String introduction;
  late String experience;
  late String timing;
  late String subjects;
  late String classes;
  late String fee;
  late String skills;
  late bool iCanVisitStudent;
  late bool studentCanVisitMe;
  late bool iCanTeachOnline;
  late String name;
  late String city;
  late String profilePic;

  TutorProfileModel({
    required this.uid,
    required this.qualification,
    required this.gender,
    required this.introduction,
    required this.experience,
    required this.timing,
    required this.subjects,
    required this.classes,
    required this.fee,
    required this.skills,
    required this.iCanVisitStudent,
    required this.studentCanVisitMe,
    required this.iCanTeachOnline,
    required this.name,
    required this.city,
    required this.profilePic
  });

  TutorProfileModel.fromMap(Map<String, dynamic> map ){

    uid = map['uid'];
    qualification = map['qualification'];
    gender = map['gender'];
    introduction = map['introduction'];
    experience = map['experience'];
    timing = map['timing'];
    subjects = map['subjects'];
    classes = map['classes'];
    fee = map['fee'];
    skills = map['skills'];
    iCanVisitStudent = map['iCanVisitStudent'];
    studentCanVisitMe = map['studentCanVisitMe'];
    iCanTeachOnline = map['iCanTeachOnline'];
    name = map['name'];
    city = map['city'];
    profilePic = map['profilePic'];
  }
}
