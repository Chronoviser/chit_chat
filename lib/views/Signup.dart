import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/ChatScreen.dart';
import 'package:chitchat/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Signup extends StatefulWidget {
  final Function toggle;

  Signup(this.toggle);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  signupNewUser() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signupWithEmailAndPassword(emailController.text,
              passwordController.text, usernameController.text)
          .then((val) {
        setState(() {
          isLoading = false;
        });
        if (val != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatScreen()));
        } else {
          Fluttertoast.showToast(
              msg: "Failed to Signup",
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
                                validator: (value) {
                                  value.trim();
                                  if (value.isEmpty || value.length < 8) {
                                    return "Username must be atleast 8 characters long";
                                  }
                                  return null;
                                },
                                controller: usernameController,
                                cursorColor: CustomColor.accentLight,
                                style: TextStyle(color: Colors.white),
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.person,
                                      color: CustomColor.hint,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: CustomColor.hint)),
                                    labelText: "Username",
                                    labelStyle: TextStyle(color: CustomColor.hint),
                                    enabledBorder: UnderlineInputBorder()),
                              ),
                              SizedBox(height: 30),
                              TextFormField(
                                validator: (email) {
                                  return RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(email)
                                      ? null
                                      : "Invalid Email";
                                },
                                controller: emailController,
                                cursorColor: CustomColor.accentLight,
                                style: TextStyle(color: Colors.white),
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
                                    labelStyle: TextStyle(color: CustomColor.hint),
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
                                cursorColor: CustomColor.accentLight,
                                style: TextStyle(color: Colors.white),
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
                                    labelStyle: TextStyle(color: CustomColor.hint),
                                    enabledBorder: UnderlineInputBorder()),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            signupNewUser();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: 45,
                              decoration: buttonDecoration(),
                              child: Center(
                                  child: Text(
                                "Sign Up",
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
                              "Sign Up with Google",
                              style: buttonTextStyle(),
                            )),
                          ),
                        ),
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("already a user? ",
                                style: TextStyle(fontSize: 14, color: Colors.white)),
                            GestureDetector(
                              onTap: () {
                                widget.toggle();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "login",
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
