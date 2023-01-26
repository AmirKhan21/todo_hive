class UserModel {
  late String uid;
  late String name;
  late String city;
  late String email;
  late String code;
  late String number;
  late String userType;
  late String profilePic;
  late int dt;
  late String qualification;

  UserModel({
    required this.uid,
    required this.name,
    required this.city,
    required this.email,
    required this.code,
    required this.number,
    required this.userType,
    required this.profilePic,
    required this.dt,
    required this.qualification,
  });

  UserModel.fromMap(Map<String, dynamic> map){
    uid = map['uid'];
    name = map['name'];
    city = map['city'];
    email = map['email'];
    code = map['code'];
    number = map['number'];
    userType = map['userType'];
    profilePic = map['profilePic'];
    dt = map['dt'];
    qualification = map['qualification'];
  }
}
