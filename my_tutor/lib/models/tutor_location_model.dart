class TutorLocationModel {
  late String uid;
  late String name;
  late String qualification;
  late num latitude;
  late num longitude;

  TutorLocationModel({
    required this.uid,
    required this.name,
    required this.qualification,
    required this.latitude,
    required this.longitude,
  });

  TutorLocationModel.fromMap( Map<String, dynamic> map){

    uid = map['uid'];
    name = map['name'];
    qualification = map['qualification'];
    latitude = map['latitude'];
    longitude = map['longitude'];
  }
}
