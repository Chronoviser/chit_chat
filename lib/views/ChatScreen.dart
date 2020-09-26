import 'package:chitchat/helper/helperfunctions.dart';
import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/P2PChatRoom.dart';
import 'package:chitchat/views/SearchScreen.dart';
import 'package:chitchat/widgets.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  String username;
  Stream chatroomStream;

  void getUserName() {
    HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        username = value;
        databaseMethods.getChatRooms(username).then((val) {
          setState(() {
            chatroomStream = val;
          });
        });
      });
    });
  }

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatroomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return chatroomTile(
                      snapshot.data.documents[index].data["users"][0],
                      snapshot.data.documents[index].data["users"][1],
                      snapshot.data.documents[index].data["chatroomId"],
                      username,
                      context);
                })
            : Center(child: chatLoader());
      },
    );
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.1),
      appBar: appBar(context, logout: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        backgroundColor: Colors.pinkAccent,
        child: Icon(
          Icons.search,
          color: Colors.white,
          size: 27,
        ),
      ),
      body: chatMessageList(),
    );
  }
}

Widget chatroomTile(final String username1, final String username2,
    final String chatroomId, final String username, BuildContext context) {
  String friend = (username1.compareTo(username) == 0) ? username2 : username1;
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => P2PChatRoom(
                  userName1: username,
                  userName2: friend,
                  chatroomId: chatroomId)));
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(25), topLeft: Radius.circular(25)),
            border: Border(
                left: BorderSide(color: CustomColor.accentLight),
                top: BorderSide(color: CustomColor.accentLight),
                bottom: BorderSide(color: CustomColor.accentLight),
                right: BorderSide(color: CustomColor.accentLight))),
        child: Row(
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: CustomColor.accent),
              child: Text(friend.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 24)),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              friend,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    ),
  );
}
