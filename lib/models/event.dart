import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final GeoPoint location;
  final String eventDate;
  final int level;
  final List participants;
  final String creator;
  final String? team;

  const Event(
      {required this.title,
      required this.location,
      required this.eventDate,
      required this.level,
      required this.participants,
      required this.creator,
      this.team});

  static Event fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Event(
        title: snapshot["title"],
        location: snapshot["location"],
        eventDate: snapshot["eventDate"],
        level: snapshot["level"],
        participants: snapshot["participants"],
        creator: snapshot["creator"],
        team: snapshot["team"]);
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "location": location,
        "eventDate": eventDate,
        "level": level,
        "participants": participants,
        "creator": creator,
        "team": team
      };
}
