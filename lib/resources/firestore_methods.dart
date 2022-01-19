import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobilki/models/invite_request.dart';
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
    QuerySnapshot<Map<String, dynamic>> teamData = await FirebaseFirestore
        .instance
        .collection("teams")
        .where("members", arrayContains: receiverUid)
        .get();
    if (teamData.docs[0]["members"].contains(receiverUid)) {
      return ["User is already in a team", true];
    } else {
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
        return ["Invitation sent succesfully!", true];
      } else {
        return ["User has pending invitation already", false];
      }
    }
  }

  static Future<dynamic> getCurrentUserRequests(
      String receiverUid, bool team) async {
    QuerySnapshot<Map<String, dynamic>> requestSnapshot =
        await FirebaseFirestore.instance
            .collection('invite_requests')
            .where('isTeam', isEqualTo: team)
            .where('receiver', isEqualTo: receiverUid)
            .get();
    List<InviteRequest> inviteData =
        requestSnapshot.docs.map((y) => (InviteRequest.fromSnap(y))).toList();
    if (inviteData.isEmpty) {
      return [false, "No invites found"];
    } else {
      List<String> senderData =
          inviteData.map((invite) => (invite.sender)).toList();
      QuerySnapshot<Map<String, dynamic>> senderSnapshot =
          await FirebaseFirestore.instance
              .collection(team ? 'teams' : 'users')
              .where(team ? "name" : "uid", whereIn: senderData)
              .get();
      print(senderSnapshot.docs);
      List<dynamic> returnData = [true, inviteData, senderSnapshot];
      if(team) {
        List<String> adminNames = [];
        QuerySnapshot<Map<String, dynamic>> adminData = await FirebaseFirestore.instance.collection('users').get();
        for(var i=0;i<senderSnapshot.docs.length;i++) {
          for(var j=0;j<adminData.docs.length;j++) {
            if(senderSnapshot.docs[i]['adminUid']==adminData.docs[j]['uid']) {
              adminNames.add(adminData.docs[j]['name']);
              break;
            } 
          }
        }
        returnData.add(adminNames);
      } 
      return returnData;
    }
  }

  static Future<void> processInviteRequest(
      String senderDocId, InviteRequest request, bool accept) async {
    await FirebaseFirestore.instance
        .collection('invite_requests')
        .doc(request.id)
        .delete();
    if (accept) {
      if (request.isTeam) {
        FirebaseFirestore.instance.collection('teams').doc(senderDocId).update({
          'members': FieldValue.arrayUnion([request.receiver])
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(request.receiver)
            .update({
          'teams': FieldValue.arrayUnion([request.sender])
        });
      } else {
        FirebaseFirestore.instance.collection('users').doc(senderDocId).update({
          'friends': FieldValue.arrayUnion([request.receiver])
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(request.receiver)
            .update({
          'friends': FieldValue.arrayUnion([request.sender])
        });
      }
    }
  }
  //TODO: dodwanie do drużyny, dodawanie do przyjaciół, dodawanie do eventu (manipulacja stanem)
}
