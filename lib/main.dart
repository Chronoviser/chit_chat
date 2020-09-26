import 'package:chitchat/helper/helperfunctions.dart';
import 'package:chitchat/views/ChatScreen.dart';
import 'package:chitchat/widgets.dart';
import 'package:flutter/material.dart';
import 'helper/authenticate.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(accentColor: CustomColor.accentLight),
      debugShowCheckedModeBanner: false,
      home: Authenticate(),
    );
  }
}
