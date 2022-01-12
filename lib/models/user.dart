import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String username;
  final String avatarUrl;
  final String dateOfBirth;
  final List friends;
  final List events;
  final List teams;

  const User({
    required this.uid,
    required this.email,
    required this.username,
    required this.avatarUrl,
    required this.dateOfBirth,
    required this.friends,
    required this.events,
    required this.teams,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        username: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        avatarUrl: snapshot["avatarUrl"],
        dateOfBirth: snapshot["dateOfBirth"],
        friends: snapshot["friends"],
        events: snapshot["events"],
        teams: snapshot["teams"]);
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "avatarUrl": avatarUrl,
        "dateOfBirth": dateOfBirth,
        "friends": friends,
        "events": events,
        "teams": teams
      };
}
