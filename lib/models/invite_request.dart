import 'package:cloud_firestore/cloud_firestore.dart';

class InviteRequest {
  final String receiver;
  final String sender;
  final bool isTeam;

  const InviteRequest({
    required this.receiver,
    required this.sender,
    required this.isTeam,
  });

  static InviteRequest fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return InviteRequest(
        receiver: snapshot["receiver"],
        sender: snapshot["sender"],
        isTeam: snapshot["isTeam"]);
  }

  Map<String, dynamic> toJson() => {
        "receiver": receiver,
        "sender": sender,
        "isTeam": isTeam
      };
}
