import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobilki/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
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
      required String username,
      required String dateOfBirth}) async {
    String res = "error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          dateOfBirth.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        model.User _user = model.User(
            uid: credential.user!.uid,
            username: username,
            email: email,
            dateOfBirth: dateOfBirth,
            avatarUrl: "",
            friends: [],
            events: [],
            teams: []);
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

  Future<void> resetPassword({required String email}) async {
    if (email.isNotEmpty) {
      await _auth.sendPasswordResetEmail(email: email);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
