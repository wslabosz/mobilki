import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/models/invite_request.dart';
import 'package:mobilki/models/team.dart';
import 'package:mobilki/models/user.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/http_methods.dart';
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
      res = avatarUrl;
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
        FirebaseFirestore.instance
            .collection("users")
            .doc(receiverUid)
            .get()
            .then((value) {
              User sender = User.fromSnap(userReference);
              User receiver = User.fromSnap(value);
          HttpMethods.sendFCMMessage(
              receiver.token, "A new invite request", "Friend request from "+sender.name.toTitleCase());
        });
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
        .where('name', isEqualTo: teamName)
        .where("members", arrayContains: receiverUid)
        .get();
    if (teamData.docs.isNotEmpty) {
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
        FirebaseFirestore.instance
            .collection("users")
            .doc(receiverUid)
            .get()
            .then((value) {
              Team sender = Team.fromSnap(teamData.docs[0]);
              User receiver = User.fromSnap(value);
          HttpMethods.sendFCMMessage(
              receiver.token, "A new team invite request", "You have been invited to "+sender.name.toTitleCase());
        });
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
      List<dynamic> returnData = [true, inviteData, senderSnapshot];
      if (team) {
        List<String> adminNames = [];
        QuerySnapshot<Map<String, dynamic>> adminData =
            await FirebaseFirestore.instance.collection('users').get();
        for (var i = 0; i < senderSnapshot.docs.length; i++) {
          for (var j = 0; j < adminData.docs.length; j++) {
            if (senderSnapshot.docs[i]['adminUid'] ==
                adminData.docs[j]['uid']) {
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
          'teams': FieldValue.arrayUnion([request.sender])});
        DocumentSnapshot<Map<String, dynamic>> teamData = await FirebaseFirestore.instance.collection('teams').doc(senderDocId).get();
        Team teamInstance = Team.fromSnap(teamData);
        DocumentSnapshot<Map<String, dynamic>> adminData = await FirebaseFirestore.instance.collection('users').doc(teamInstance.adminUid).get();
        User adminInstance = User.fromSnap(adminData);
        DocumentSnapshot<Map<String, dynamic>> receiverData = await FirebaseFirestore.instance.collection('users').doc(request.receiver).get();
        User receiverInstance = User.fromSnap(receiverData);
                  HttpMethods.sendFCMMessage(
              adminInstance.token, "A new member joined your team!", receiverInstance.name.toTitleCase()+" has accepted your invitation.");
        }
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
        DocumentSnapshot<Map<String, dynamic>> senderData = await FirebaseFirestore.instance.collection('users').doc(request.sender).get();
        User senderInstance = User.fromSnap(senderData);
        DocumentSnapshot<Map<String, dynamic>> receiverData = await FirebaseFirestore.instance.collection('users').doc(request.receiver).get();
        User receiverInstance = User.fromSnap(receiverData);
        HttpMethods.sendFCMMessage(
              senderInstance.token, "You have a new friend!", receiverInstance.name.toTitleCase()+" has accepted your friend request.");
      }
    }

  static Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = AuthMethods().getUserUID();
    if (userId != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'token': token,
      });
    }
  }

  static Future<void> deleteFriend(String uid1, String uid2) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid1)
        .update({"friends":FieldValue.arrayRemove([uid2])});
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid2)
        .update({"friends":FieldValue.arrayRemove([uid1])});
  }

  static Future<dynamic> addTeam(String name) async {
    if(name.length<5) {
      return ["Team name is too short!",false];
    }
    if(name.length>30) {
      return ['Team name is too long',false];
    }
    QuerySnapshot<Map<String, dynamic>> teamsWithSameName = await FirebaseFirestore.instance.collection('teams').where('name',isEqualTo:name).get();
    if(teamsWithSameName.docs.isNotEmpty) {
      return ['Team with that name already exists',false];
    }
    FirebaseFirestore.instance.collection('teams').add(Team(name:name,adminUid:AuthMethods().getUserUID(),avatarUrl:"",members:[AuthMethods().getUserUID()],events:[""]).toJson());
    FirebaseFirestore.instance.collection('users').doc(AuthMethods().getUserUID()).update({'teams':FieldValue.arrayUnion([name])});
    return ['Successfuly added the team!',true];
  }

  static Future<void> deleteMember(String teamName, String memberUid) async {
      QuerySnapshot<Map<String, dynamic>> teamToUpdate = await FirebaseFirestore.instance.collection('teams').where('name',isEqualTo: teamName).get();
      await teamToUpdate.docs[0].reference.update({'members':FieldValue.arrayRemove([memberUid])});
      await FirebaseFirestore.instance.collection('users').doc(memberUid).update({'teams':FieldValue.arrayRemove([teamName])});
  }

  static Future<void> deleteTeam(String teamUid, String teamName, List<String> members) async {
    await FirebaseFirestore.instance.collection('teams').doc(teamUid).delete();
    for(var member in members) {
      FirebaseFirestore.instance.collection('users').doc(member).update({'teams':FieldValue.arrayRemove([teamName])});
    }
  }

  //TODO: dodwanie do drużyny, dodawanie do przyjaciół, dodawanie do eventu (manipulacja stanem)
}
