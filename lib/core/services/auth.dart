import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      print("the email im logging in with is $email");
      print("the password im logging in with is $password");
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User fireBaseUser = result.user;
      return fireBaseUser != null ? fireBaseUser.uid : null;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(
      String email, String password, String userName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print('response is ${result.user}');
      await result.user.updateProfile(displayName: userName);
      User fireBaseUser = result.user;
      return fireBaseUser != null ? fireBaseUser.uid : null;
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
