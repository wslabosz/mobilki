import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'username:': username,
          'email': email,
          'dateOfBirth': dateOfBirth,
          'avatarUrl': '',
          'friends': [],
          'events': [],
          'teams': []
        });
        //await _firestore.collection('users')
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
