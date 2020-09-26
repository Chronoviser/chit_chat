import 'package:chitchat/services/database.dart';
import 'package:chitchat/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class P2PChatRoom extends StatefulWidget {
  final userName1;
  final userName2;
  final chatroomId;

  P2PChatRoom({this.userName1, this.userName2, this.chatroomId});

  @override
  _P2PChatRoomState createState() => _P2PChatRoomState();
}

class _P2PChatRoomState extends State<P2PChatRoom> {
  TextEditingController messageController = TextEditingController();
  static DatabaseMethods databaseMethods = DatabaseMethods();
  Stream chatMessagesStream;
  //QuerySnapshot snapshot;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return chatLoader();
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return messgaeTile(
                  snapshot.data.documents[index].data["message"],
                  snapshot.data.documents[index].data["sendby"],
                  widget.userName1,
                  context);
            });
      },
    );
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatroomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.black,
      appBar: AppBar(
        title: Text(
          '${widget.userName2}',
          style: TextStyle(
              fontFamily: 'PatrickHand', fontSize: 30, color: cream()),
        ),
        centerTitle: true,
        elevation: 0.1,
        backgroundColor: CustomColor.accent,
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 60),
                child: chatMessageList()),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: CustomColor.black,
                  border: Border(
                      left: BorderSide(color: Colors.white10),
                      top: BorderSide(color: Colors.white10),
                      right: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 5),
                          child: TextField(
                            controller: messageController,
                            cursorColor: CustomColor.accentLight,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Type a message",
                                hintStyle: TextStyle(color: CustomColor.hint),
                                border: InputBorder.none),
                          )),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(colors: [
                                CustomColor.accent,
                                CustomColor.accentLight
                              ])),
                          child: IconButton(
                            onPressed: () {
                              if (messageController.text.isNotEmpty) {
                                databaseMethods.sendConversationMessages(
                                    widget.chatroomId, {
                                  "message": messageController.text,
                                  "sendby": widget.userName1,
                                  "time": DateTime.now().millisecondsSinceEpoch
                                });
                                messageController.text = "";
                              }
                            },
                            splashRadius: 25,
                            splashColor: Colors.teal,
                            color: Colors.white,
                            icon: Icon(Icons.send),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget messgaeTile(final String message, final String sendUser,
    final String currentUser, BuildContext context) {
  bool sentByMe = (sendUser.compareTo(currentUser) == 0);
  Color messageColor = sentByMe ? Colors.blue : Colors.lightGreenAccent;

  return Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(color: messageColor),
              right: BorderSide(color: messageColor),
              top: BorderSide(color: messageColor),
              bottom: BorderSide(color: messageColor)),
          borderRadius: sentByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23))),
      child: Text(
        message,
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}
