import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  final String name;
  final String adminUid;
  final String avatarUrl;
  final List members;
  final List events;
  final String? uid;

  const Team({
    required this.name,
    required this.adminUid,
    required this.avatarUrl,
    required this.members,
    required this.events,
    this.uid
  });

  static Team fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Team(
        name: snapshot["name"],
        adminUid: snapshot["adminUid"],
        avatarUrl: snapshot["avatarUrl"],
        members: snapshot["members"],
        events: snapshot["events"],
        uid: snap.id);
        
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "adminUid": adminUid,
        "avatarUrl": avatarUrl,
        "members": members,
        "events": events
      };
}
