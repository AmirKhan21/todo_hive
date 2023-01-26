class ChatModel {
  late String idFrom;
  late String idTo;
  late String timestamp;
  late String message;

  ChatModel({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.message,
  });

  ChatModel.fromMap(Map<String, dynamic> map){
    idFrom = map['idFrom'];
    idTo = map['idTo'];
    timestamp = map['timestamp'];
    message = map['message'];
  }
}
