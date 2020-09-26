import 'package:chitchat/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'helper/authenticate.dart';

Widget appBar(BuildContext context, {bool logout = false}) {
  AuthMethods authMethods = AuthMethods();
  return AppBar(
    title: Text(
      "Chit ☕ Chat",
      style:
          TextStyle(fontFamily: 'KaushanScript', fontSize: 30, color: cream()),
    ),
    centerTitle: true,
    elevation: 0.1,
    backgroundColor: CustomColor.accent,
    actions: (!logout)
        ? []
        : [
            GestureDetector(
              onTap: () {
                authMethods.signout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Icon(Icons.exit_to_app, color: cream(), size: 26)),
            ),
          ],
  );
}

Color cream() {
  return Color.fromRGBO(255, 253, 208, 1);
}

Color darkCream() {
  return Color.fromRGBO(255, 252, 125, 1);
}

TextStyle buttonTextStyle() {
  return TextStyle(fontFamily: 'Roboto', color: Colors.white, fontSize: 24);
}

BoxDecoration buttonDecoration() {
  return BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      gradient: LinearGradient(
          colors: [CustomColor.accent, CustomColor.accentLight]));
}

Widget circularProgressIndicator(BuildContext context) {
  return Center(
      child: Container(
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    height: MediaQuery.of(context).size.height,
    child: SizedBox(
      height: 150,
      width: 150,
      child: CircularProgressIndicator(
        backgroundColor: CustomColor.accent,
        valueColor: AlwaysStoppedAnimation<Color>(cream()),
        strokeWidth: 45,
      ),
    ),
  ));
}

Widget lottieLoader(BuildContext context) {
  return Center(child: Container(
    height: 400,
    width: 400,
    child: LottieBuilder.asset('assets/animations/star.json'),
  ));
}

Widget chatLoader() {
  return Center(child: Container(
    height: 250,
    width: 250,
    child: LottieBuilder.asset('assets/animations/chatloader.json'),
  ));
}

Widget namasteLoader() {
  return Center(child: Container(
    height: 150,
    width: 150,
    child: LottieBuilder.asset('assets/animations/namaste.json'),
  ));
}

class CustomColor {
  static Color accent = Colors.pinkAccent.withOpacity(0.9);
  static Color accentLight = Colors.pinkAccent;
  static Color black = Colors.white.withOpacity(0.1);
  static Color hint = Colors.white.withOpacity(0.5);
  static Color white = Colors.white;
}
