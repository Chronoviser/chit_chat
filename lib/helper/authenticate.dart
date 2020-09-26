import 'package:chitchat/helper/helperfunctions.dart';
import 'package:chitchat/views/ChatScreen.dart';
import 'package:chitchat/views/Signin.dart';
import 'package:chitchat/views/Signup.dart';
import 'package:chitchat/widgets.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignin = true;
  bool alreadySignedin;

  setUpalreadySignedin() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        alreadySignedin = value;
      });
    });
  }

  @override
  void initState() {
    setUpalreadySignedin();
    super.initState();
  }

  void toggleView() {
    setState(() {
      showSignin = !showSignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return alreadySignedin == null
        ? lottieLoader(context)
        : alreadySignedin == true
            ? ChatScreen()
            : showSignin ? Signin(toggleView) : Signup(toggleView);
  }
}
