import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobilki/resources/storage_methods.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadAvatar(Uint8List file, String uid,
      {String collection = 'users'}) async {
    String res = "error occurred";
    try {
      String avatarUrl =
          await StorageMethods().uploadImageToStorage('avatars', file, true);
      _firestore
          .collection(collection)
          .doc(uid)
          .update({"avatarUrl": avatarUrl});
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<List> sendFriendRequest(
      String senderUid, String receiverUid) async {
    List returnData = ["Something went wrong", false];
    DocumentSnapshot<Map<String, dynamic>> userReference;
    userReference = await FirebaseFirestore.instance
        .collection('users')
        .doc(senderUid)
        .get();
    if ((userReference['friends'] as List).contains(receiverUid)) {
      returnData = ["User is already your friend", false];
    } else {
      QuerySnapshot<Map<String, dynamic>> sameInviteRequests;
      sameInviteRequests = await FirebaseFirestore.instance
          .collection('invite_requests')
          .where('isTeam', isEqualTo: false)
          .where('sender', isEqualTo: senderUid)
          .where('receiver', isEqualTo: receiverUid)
          .get();
      if (sameInviteRequests.docs.isEmpty) {
        FirebaseFirestore.instance.collection("invite_requests").add(
            {'isTeam': false, 'sender': senderUid, 'receiver': receiverUid});
        returnData = ["Invitation sent succesfully!", true];
      } else {
        returnData = ["User has pending invitation already", false];
      }
    }
    return returnData;
  }

  static Future<List> sendTeamRequest(
      String teamName, String receiverUid) async {
    List returnData = ["Something went wrong", false];
    QuerySnapshot<Map<String, dynamic>> sameInviteRequests =
        await FirebaseFirestore.instance
            .collection("invite_requests")
            .where('isTeam', isEqualTo: true)
            .where('sender', isEqualTo: teamName)
            .where('receiver', isEqualTo: receiverUid)
            .get();
    if (sameInviteRequests.docs.isEmpty) {
      FirebaseFirestore.instance
          .collection("invite_requests")
          .add({'isTeam': true, 'sender': teamName, 'receiver': receiverUid});
      returnData = ["Invitation sent succesfully!", true];
    } else {
      returnData = ["User has pending invitation already", false];
    }
    return returnData;
  }
  //TODO: dodwanie do drużyny, dodawanie do przyjaciół, dodawanie do eventu (manipulacja stanem)
}
