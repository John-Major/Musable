import 'package:flutter/material.dart';
import 'package:flutterproject1/core/widgets/text_style.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userNameTextEditController =
      new TextEditingController();
  TextEditingController emailTextEditController = new TextEditingController();
  TextEditingController passwordTextEditController =
      new TextEditingController();

  void signMeUp() {
    if (formKey.currentState.validate()) {}
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      appBar: AppBar(
        title: Text("Sign Up"),
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
                        controller: userNameTextEditController,
                        style: customTextStyle(Colors.white, 16),
                        decoration: textFieldInputDecoration("username"),
                      ),
                      TextFormField(
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
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Already have an account?",
                        style: customTextStyle(Colors.white, 16)),
                  ),
                ),
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
