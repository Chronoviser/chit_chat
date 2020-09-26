import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ChatScreen.dart';

class Signin extends StatefulWidget {
  final Function toggle;

  Signin(this.toggle);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot snapshot;

  signInUser() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      String username =
          snapshot == null ? "DEFAULT" : snapshot.documents[0].data['username'];
      authMethods
          .signinWithEmailAndPassword(
              emailController.text, passwordController.text, username)
          .then((val) {
        setState(() {
          isLoading = false;
        });

        if (val != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatScreen()));
        } else {
          Fluttertoast.showToast(
              msg: "Failed to Login",
              backgroundColor: Colors.black.withOpacity(0.8),
              textColor: Colors.white);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: CustomColor.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: isLoading
              ? lottieLoader(context)
              : Container(
                  height: MediaQuery.of(context).size.height - 80,
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        namasteLoader(),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (email) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(email)
                                      ? null
                                      : "Invalid Email";
                                },
                                style: TextStyle(color: Colors.white),
                                controller: emailController,
                                cursorColor: CustomColor.accentLight,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.email,
                                      color: CustomColor.hint,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: CustomColor.hint)),
                                    labelText: "Email",
                                    labelStyle:
                                        TextStyle(color: CustomColor.hint),
                                    enabledBorder: UnderlineInputBorder()),
                              ),
                              SizedBox(height: 30),
                              TextFormField(
                                validator: (password) {
                                  return password.length >= 8
                                      ? null
                                      : "Password must be atleast 8 characters long";
                                },
                                controller: passwordController,
                                style: TextStyle(color: Colors.white),
                                cursorColor: CustomColor.accentLight,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.vpn_key,
                                      color: CustomColor.hint,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: CustomColor.hint)),
                                    labelText: "Password",
                                    labelStyle:
                                        TextStyle(color: CustomColor.hint),
                                    enabledBorder: UnderlineInputBorder()),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot Password?",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.teal),
                            )),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            databaseMethods
                                .getUserByEmail(emailController.text)
                                .then((val) {
                              setState(() {
                                snapshot = val;
                                signInUser();
                              });
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: 45,
                              decoration: buttonDecoration(),
                              child: Center(
                                  child: Text(
                                "Sign In",
                                style: buttonTextStyle(),
                              )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: 45,
                            decoration: buttonDecoration(),
                            child: Center(
                                child: Text(
                              "Sign In with Google",
                              style: buttonTextStyle(),
                            )),
                          ),
                        ),
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("new user? ", style: TextStyle(fontSize: 14, color: CustomColor.white)),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "register",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        )),
                        SizedBox(height: 40)
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
