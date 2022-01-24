import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String name;
  final String avatarUrl;
  final String dateOfBirth;
  final List friends;
  final List events;
  final List teams;
  final String token;

  const User(
      {required this.uid,
      required this.email,
      required this.name,
      required this.avatarUrl,
      required this.dateOfBirth,
      required this.friends,
      required this.events,
      required this.teams,
      required this.token});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
        name: snapshot["name"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        avatarUrl: snapshot["avatarUrl"],
        dateOfBirth: snapshot["dateOfBirth"],
        friends: snapshot["friends"],
        events: snapshot["events"],
        teams: snapshot["teams"],
        token: snapshot['token']);
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "uid": uid,
        "email": email,
        "avatarUrl": avatarUrl,
        "dateOfBirth": dateOfBirth,
        "friends": friends,
        "events": events,
        "teams": teams
      };
  int getAge() {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - int.parse(dateOfBirth.substring(0, 4));
    int month1 = currentDate.month;
    int month2 = int.parse(dateOfBirth.substring(5, 7));
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = int.parse(dateOfBirth.substring(8, 10));
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
