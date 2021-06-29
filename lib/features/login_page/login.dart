import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject1/application.dart';
import 'package:flutterproject1/core/services/auth.dart';
import 'package:flutterproject1/core/services/database.dart';
import 'package:flutterproject1/core/widgets/text_style.dart';
import 'package:flutterproject1/features/login_page/sign_up.dart';
import 'package:flutterproject1/helper/helper_functions.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditController = new TextEditingController();
  TextEditingController passwordTextEditController =
      new TextEditingController();

  void signIn() async {
    if (formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditController.text.trim());

      print("should print1");
      databaseMethods
          .getUserInfo(emailTextEditController.text.trim())
          .then((val) {
        print('should print here');
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference("naruza");
        //snapshotUserInfo.docs.elementAt(0).get('name')
        print("should print");
        setState(() {
          isLoading = true;
        });
      });
      print("the email is: ${emailTextEditController.text.trim()}");
      print("the password is: ${passwordTextEditController.text.trim()}");
      await authMethods
          .signInWithEmailAndPassword(emailTextEditController.text.trim(),
              passwordTextEditController.text.trim())
          .catchError((onError) {
        print("THE ERROR IS" + onError.toString());
      })
          //emailTextEditController.text, passwordTextEditController.text
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyStatefulWidget()));
        } else {
          print("gg");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          return val.isEmpty ? "Field is Empty" : null;
                        },

                        /*
validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Enter correct email";
                        },
                        */

                        controller: emailTextEditController,
                        style: customTextStyle(Colors.white, 16),
                        decoration: textFieldInputDecoration("email"),
                      ),
                      TextFormField(
                        validator: (val) {
                          return val.isEmpty ? "Field is Empty" : null;
                        },
                        controller: passwordTextEditController,
                        style: customTextStyle(Colors.white, 16),
                        decoration: textFieldInputDecoration("password"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Forgot Password?",
                        style: customTextStyle(Colors.white, 16)),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ]),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text("Sign In",
                        style: customTextStyle(Colors.white, 17)),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text("Sign In with Google",
                      style: customTextStyle(Colors.black, 17)),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: customTextStyle(Colors.white, 12)),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        child: Text(" Register now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                decoration: TextDecoration.underline)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names

//Can put these in another file
Widget customAppBar(BuildContext context) {
  return AppBar(
    title: Text("Custom App Bar"),
  );
}
