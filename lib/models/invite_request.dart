import 'package:cloud_firestore/cloud_firestore.dart';

class InviteRequest {
  final String id;
  final String receiver;
  final String sender;
  final bool isTeam;

  const InviteRequest({
    required this.id,
    required this.receiver,
    required this.sender,
    required this.isTeam,
  });

  static InviteRequest fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return InviteRequest(
        id: snap.id,
        receiver: snapshot["receiver"],
        sender: snapshot["sender"],
        isTeam: snapshot["isTeam"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "receiver": receiver,
        "sender": sender,
        "isTeam": isTeam
      };
}
