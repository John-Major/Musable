import 'package:flutter/material.dart';
import 'package:flutterproject1/application.dart';
import 'package:flutterproject1/core/services/auth.dart';
import 'package:flutterproject1/core/services/database.dart';
import 'package:flutterproject1/core/widgets/background_home_page.dart';
import 'package:flutterproject1/core/widgets/text_style.dart';
import 'package:flutterproject1/helper/helper_functions.dart';

class SignUp extends StatefulWidget {
  final Function toggle;

  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  TextEditingController userNameTextEditController =
      new TextEditingController();
  TextEditingController emailTextEditController = new TextEditingController();
  TextEditingController passwordTextEditController =
      new TextEditingController();
// home , songs 10 => chat
//

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods database = new DatabaseMethods();

  void signMeUp() {
    Map<String, String> userInfoMap = {
      'name': userNameTextEditController.text.trim(),
      'email': emailTextEditController.text.trim()
    };
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
    }

    HelperFunctions.saveUserEmailSharedPreference(
        emailTextEditController.text.trim());
    HelperFunctions.saveUserNameSharedPreference(
        userNameTextEditController.text.trim());

    authMethods
        .signUpWithEmailAndPassword(emailTextEditController.text,
            passwordTextEditController.text, userNameTextEditController.text)
        .then((val) {
      //print('$val');

      database.addUserInfo(userInfoMap);

      HelperFunctions.saveUserLoggedInSharedPreference(true);
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => MyStatefulWidget()));
    });
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: isLoading
          ? Container(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                              controller: userNameTextEditController,
                              style: customTextStyle(Colors.white, 16),
                              decoration: textFieldInputDecoration("username"),
                            ),
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Enter correct email";
                              },
                              controller: emailTextEditController,
                              style: customTextStyle(Colors.white, 16),
                              decoration: textFieldInputDecoration("email"),
                            ),
                            TextFormField(
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
                      GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text("Already have an account?",
                                  style: customTextStyle(Colors.white, 16)),
                            ),
                          )),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeUp();
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
                          child: Text("Sign Up",
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
                        child: Text("Sign Up with Google",
                            style: customTextStyle(Colors.black, 17)),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an accountt?",
                              style: customTextStyle(Colors.white, 12)),
                          Text(" Sign In now",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline)),
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
