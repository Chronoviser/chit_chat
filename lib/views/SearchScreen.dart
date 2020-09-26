import 'package:chitchat/helper/helperfunctions.dart';
import 'package:chitchat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets.dart';
import 'P2PChatRoom.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  static DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot snapshot;

  static createChatRoomAndStartConversation(
      String userName2, BuildContext context) async {
    String chatRoomId = "";
    String userName1 = await HelperFunctions.getUserNameSharedPreference();
    if (userName1 != userName2) {
      if (userName1.compareTo(userName2) <= 0) {
        chatRoomId = userName1 + "!_!" + userName2;
      } else {
        chatRoomId = userName2 + "!_!" + userName1;
      }
      databaseMethods.createChatRoom(chatRoomId, {
        'chatroomId': chatRoomId,
        'users': [userName1, userName2]
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => P2PChatRoom(
                  userName1: userName1,
                  userName2: userName2,
                  chatroomId: chatRoomId)));
    } else {
      Fluttertoast.showToast(
          msg: "You cannot send messages to yourself",
          backgroundColor: Colors.black.withOpacity(0.8),
          textColor: Colors.white);
    }
  }

  Widget SearchList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.documents.length,
        itemBuilder: (context, index) {
          return SearchListTile(
              searchedUsername: snapshot.documents[index].data['username'],
              searchedEmail: snapshot.documents[index].data['email']);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: CustomColor.black,
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                    color: CustomColor.black,
                    border: Border(
                        top: BorderSide(color: Colors.white10),
                        left: BorderSide(color: Colors.white10),
                        right: BorderSide(color: Colors.white10),
                        bottom: BorderSide(color: Colors.white10)),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                          height: 50,
                          margin: EdgeInsets.only(left: 5),
                          child: TextField(
                            controller: searchController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Enter username",
                                hintStyle: TextStyle(color: CustomColor.hint),
                                border: InputBorder.none),
                          )),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: LinearGradient(colors: [
                                CustomColor.accent,
                                CustomColor.black
                              ])),
                          child: IconButton(
                            onPressed: () {
                              databaseMethods
                                  .getUserByUsername(searchController.text)
                                  .then((val) {
                                setState(() {
                                  snapshot = val;
                                });
                              });
                            },
                            splashRadius: 25,
                            color: Colors.white,
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                  height: MediaQuery.of(context).size.height / 1.4,
                  child: snapshot == null ? Container() : SearchList())
            ]),
          ),
        ),
      ),
    );
  }
}

class SearchListTile extends StatelessWidget {
  final searchedUsername;
  final searchedEmail;

  SearchListTile({this.searchedUsername, this.searchedEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(searchedUsername,
                  style: TextStyle(fontSize: 16, color: CustomColor.white)),
              Text(
                searchedEmail,
                style: TextStyle(fontSize: 14, color: CustomColor.hint),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              _SearchScreenState.createChatRoomAndStartConversation(
                  searchedUsername, context);
            },
            child: Container(
              height: 30,
              width: 90,
              decoration: BoxDecoration(
                  color: CustomColor.accent,
                  borderRadius: BorderRadius.circular(25)),
              child: Center(
                  child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
            ),
          )
        ],
      ),
    );
  }
}
