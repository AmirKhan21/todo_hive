class ChatBoxModel {
  late String currentUserId;
  late String peerId;
  late String chatId;
  late String peerName;
  late String peerProfilePic;
  late String lastMessage;

  ChatBoxModel({
    required this.currentUserId,
    required this.peerId,
    required this.chatId,
    required this.peerName,
    required this.peerProfilePic,
    required this.lastMessage,
  });

  ChatBoxModel.fromMap(Map<String, dynamic> map){
    currentUserId = map['currentUserId'];
    peerId = map['peerId'];
    chatId = map['chatId'];
    peerName = map['peerName'];
    peerProfilePic = map['peerProfilePic'];
    lastMessage = map['lastMessage'];
  }
}
