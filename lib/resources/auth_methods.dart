import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobilki/models/user.dart' as model;

class AuthMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(documentSnapshot);
  }

  String getUserUID() {
    return _auth.currentUser!.uid;
  }

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String name,
      required String dateOfBirth}) async {
    String res = "error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          name.isNotEmpty ||
          dateOfBirth.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        model.User _user = model.User(
            uid: credential.user!.uid,
            name: name,
            email: email,
            dateOfBirth: dateOfBirth,
            avatarUrl: "",
            friends: [],
            events: [],
            teams: [],
            token: "");
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(_user.toJson());
        res = "success";
      } else {
        res = "Please enter all the needed fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all needed fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> resetPassword({required String email}) async {
    String res = "error occured";
    try {
      if (email.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: email);
        res = "success";
      } else {
        res = "please enter the email";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
