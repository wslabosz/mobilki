import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/models/invite_request.dart';
import 'package:mobilki/models/team.dart';
import 'package:mobilki/models/user.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/http_methods.dart';
import 'package:mobilki/resources/storage_methods.dart';

class FireStoreMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> uploadAvatar(Uint8List file, String uid,
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

  static Future<String> createEvent(
      {required String title,
      required GeoPoint location,
      required String eventDate,
      required int level,
      required String creator,
      String? team}) async {
    String res = "error occurred";
    try {
      if (title.isNotEmpty || eventDate.isNotEmpty || creator.isNotEmpty) {
        Event _event = Event(
            title: title,
            location: location,
            eventDate: eventDate,
            level: level,
            participants: [creator],
            creator: creator,
            team: team);
        DocumentReference<Map<String, dynamic>> newEvent = _firestore.collection('events').doc();
        await newEvent.set(_event.toJson());
        await _firestore.collection('users').doc(creator).update({'events':FieldValue.arrayUnion([newEvent.id])});
        res = "success";
      } else {
        res = "Please enter all the needed fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  static Future<List> sendFriendRequest(
      String senderUid, String receiverUid) async {
    List returnData = ["Something went wrong", false];
    DocumentSnapshot<Map<String, dynamic>> userReference;
    userReference = await _firestore.collection('users').doc(senderUid).get();
    if ((userReference['friends'] as List).contains(receiverUid)) {
      returnData = ["User is already your friend", false];
    } else {
      QuerySnapshot<Map<String, dynamic>> sameInviteRequests;
      sameInviteRequests = await _firestore
          .collection('invite_requests')
          .where('isTeam', isEqualTo: false)
          .where('sender', isEqualTo: senderUid)
          .where('receiver', isEqualTo: receiverUid)
          .get();
      if (sameInviteRequests.docs.isEmpty) {
        _firestore.collection("invite_requests").add(
            {'isTeam': false, 'sender': senderUid, 'receiver': receiverUid});
        returnData = ["Invitation sent succesfully!", true];
        _firestore.collection("users").doc(receiverUid).get().then((value) {
          User sender = User.fromSnap(userReference);
          User receiver = User.fromSnap(value);
          HttpMethods.sendFCMMessage(receiver.token, "A new invite request",
              "Friend request from " + sender.name.toTitleCase());
        });
      } else {
        returnData = ["User has pending invitation already", false];
      }
    }
    return returnData;
  }

  static Future<List> sendTeamRequest(
      String teamName, String receiverUid) async {
    QuerySnapshot<Map<String, dynamic>> teamData = await _firestore
        .collection("teams")
        .where('name', isEqualTo: teamName)
        .where("members", arrayContains: receiverUid)
        .get();
    if (teamData.docs.isNotEmpty) {
      return ["User is already in a team", true];
    } else {
      QuerySnapshot<Map<String, dynamic>> sameInviteRequests = await _firestore
          .collection("invite_requests")
          .where('isTeam', isEqualTo: true)
          .where('sender', isEqualTo: teamName)
          .where('receiver', isEqualTo: receiverUid)
          .get();
      if (sameInviteRequests.docs.isEmpty) {
        _firestore
            .collection("invite_requests")
            .add({'isTeam': true, 'sender': teamName, 'receiver': receiverUid});
        _firestore.collection("users").doc(receiverUid).get().then((value) {
          Team sender = Team.fromSnap(teamData.docs[0]);
          User receiver = User.fromSnap(value);
          HttpMethods.sendFCMMessage(
              receiver.token,
              "A new team invite request",
              "You have been invited to " + sender.name.toTitleCase());
        });
        return ["Invitation sent succesfully!", true];
      } else {
        return ["User has pending invitation already", false];
      }
    }
  }

  static Stream<QuerySnapshot> getEvents() {
    Stream<QuerySnapshot> _eventsStream = _firestore
        .collection('events')
        .where('team', isNull: true)
        .where('eventDate', isGreaterThan: DateTime.now().toString())
        .orderBy('eventDate')
        .snapshots();
    return _eventsStream;
  }

  static Stream<QuerySnapshot> getTeamEvents(String teamName) {
      Stream<QuerySnapshot> _teamEventsStream = _firestore
          .collection('events')
          .where('team', isEqualTo: teamName)
          .where('eventDate', isGreaterThan: DateTime.now().toString())
          .orderBy('eventDate')
          .snapshots();
    return _teamEventsStream;
  }

  static Future<dynamic> getCurrentUserRequests(
      String receiverUid, bool team) async {
    QuerySnapshot<Map<String, dynamic>> requestSnapshot = await _firestore
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
      QuerySnapshot<Map<String, dynamic>> senderSnapshot = await _firestore
          .collection(team ? 'teams' : 'users')
          .where(team ? "name" : "uid", whereIn: senderData)
          .get();
      List<dynamic> returnData = [true, inviteData, senderSnapshot];
      if (team) {
        List<String> adminNames = [];
        QuerySnapshot<Map<String, dynamic>> adminData =
            await _firestore.collection('users').get();
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
    await _firestore.collection('invite_requests').doc(request.id).delete();
    if (accept) {
      if (request.isTeam) {
        _firestore.collection('teams').doc(senderDocId).update({
          'members': FieldValue.arrayUnion([request.receiver])
        });
        _firestore.collection('users').doc(request.receiver).update({
          'teams': FieldValue.arrayUnion([request.sender])
        });
        DocumentSnapshot<Map<String, dynamic>> teamData =
            await _firestore.collection('teams').doc(senderDocId).get();
        Team teamInstance = Team.fromSnap(teamData);
        DocumentSnapshot<Map<String, dynamic>> adminData = await _firestore
            .collection('users')
            .doc(teamInstance.adminUid)
            .get();
        User adminInstance = User.fromSnap(adminData);
        DocumentSnapshot<Map<String, dynamic>> receiverData =
            await _firestore.collection('users').doc(request.receiver).get();
        User receiverInstance = User.fromSnap(receiverData);
        HttpMethods.sendFCMMessage(
            adminInstance.token,
            "A new member joined your team!",
            receiverInstance.name.toTitleCase() +
                " has accepted your invitation.");
      } else {
        _firestore.collection('users').doc(senderDocId).update({
          'friends': FieldValue.arrayUnion([request.receiver])
        });
        _firestore.collection('users').doc(request.receiver).update({
          'friends': FieldValue.arrayUnion([request.sender])
        });
        DocumentSnapshot<Map<String, dynamic>> senderData =
            await _firestore.collection('users').doc(request.sender).get();
        User senderInstance = User.fromSnap(senderData);
        DocumentSnapshot<Map<String, dynamic>> receiverData =
            await _firestore.collection('users').doc(request.receiver).get();
        User receiverInstance = User.fromSnap(receiverData);
        HttpMethods.sendFCMMessage(
            senderInstance.token,
            "You have a new friend!",
            receiverInstance.name.toTitleCase() +
                " has accepted your friend request.");
      }
    }
  }

  static Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example
    String userId = AuthMethods().getUserUID();
    if (userId != null) {
      await _firestore.collection('users').doc(userId).update({
        'token': token,
      });
    }
  }

  static Future<void> deleteFriend(String uid1, String uid2) async {
    _firestore.collection('users').doc(uid1).update({
      "friends": FieldValue.arrayRemove([uid2])
    });
    _firestore.collection('users').doc(uid2).update({
      "friends": FieldValue.arrayRemove([uid1])
    });
  }

  static Future<dynamic> addTeam(String name) async {
    if (name.length < 5) {
      return ["Team name is too short!", false];
    }
    if (name.length > 30) {
      return ['Team name is too long', false];
    }
    QuerySnapshot<Map<String, dynamic>> teamsWithSameName = await _firestore
        .collection('teams')
        .where('name', isEqualTo: name)
        .get();
    if (teamsWithSameName.docs.isNotEmpty) {
      return ['Team with that name already exists', false];
    }
    _firestore.collection('teams').add(Team(
        name: name,
        adminUid: AuthMethods().getUserUID(),
        avatarUrl: "",
        members: [AuthMethods().getUserUID()],
        events: [""]).toJson());
    _firestore.collection('users').doc(AuthMethods().getUserUID()).update({
      'teams': FieldValue.arrayUnion([name])
    });
    return ['Successfuly added the team!', true];
  }

  static Future<void> deleteMember(String teamName, String memberUid) async {
    QuerySnapshot<Map<String, dynamic>> teamToUpdate = await _firestore
        .collection('teams')
        .where('name', isEqualTo: teamName)
        .get();
    await teamToUpdate.docs[0].reference.update({
      'members': FieldValue.arrayRemove([memberUid])
    });
    await _firestore.collection('users').doc(memberUid).update({
      'teams': FieldValue.arrayRemove([teamName])
    });
  }

  static Future<void> deleteTeam(
      String teamUid, String teamName, List<String> members) async {
    await _firestore.collection('teams').doc(teamUid).delete();
    for (var member in members) {
      _firestore.collection('users').doc(member).update({
        'teams': FieldValue.arrayRemove([teamName])
      });
    }
  }

  static Future<List<String>> getEventFutureData(
      String adminUid, GeoPoint geopoint) async {
    List<String> returnData = [];
    List<Placemark> placemarkList =
        await placemarkFromCoordinates(geopoint.latitude, geopoint.longitude);
    returnData.add(placemarkList[0].street!);
    DocumentSnapshot<Map<String, dynamic>> adminData =
        await _firestore.collection('users').doc(adminUid).get();
    User admin = User.fromSnap(adminData);
    returnData.add(admin.avatarUrl);
    return returnData;
  }
}
