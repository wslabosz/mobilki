import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobilki/resources/storage_methods.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadAvatar(Uint8List file, String uid, {String collection='users'}) async {
    String res = "error occurred";
    try {
      String avatarUrl = await StorageMethods().uploadImageToStorage('avatars', file, true);
      _firestore.collection(collection).doc(uid).update({"avatarUrl": avatarUrl});
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  //TODO: dodwanie do drużyny, dodawanie do przyjaciół, dodawanie do eventu (manipulacja stanem)
}