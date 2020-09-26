import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .getDocuments();
  }

  getUserByEmail(String email) async {
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatroomId, chatRoomMap) {
    Firestore.instance
        .collection("chatroom")
        .document(chatroomId)
        .setData(chatRoomMap);
  }

  sendConversationMessages(String chatroomId, messageMap) {
    Firestore.instance
        .collection("chatroom")
        .document(chatroomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print('sendConversationMessage: $e');
    });
  }

  getConversationMessages(String chatroomId) async {
    return Firestore.instance
        .collection("chatroom")
        .document(chatroomId)
        .collection("chats")
        .orderBy("time")
        .snapshots();
  }

  getChatRooms(String username) async {
    print('Inside getChatRooms: $username');
    return Firestore.instance
        .collection("chatroom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
