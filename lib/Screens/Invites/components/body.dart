import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/components/member_list.dart';
import 'package:mobilki/components/segmeneted_control.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/models/invite_request.dart';
import 'package:mobilki/models/team.dart';
import 'package:mobilki/models/user.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/firestore_methods.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  bool _rightSegment = false;

  void _switchSegment(bool right) {
    setState(() {
      _rightSegment = right;
    });
  }

  void processInvite(String senderDocId, InviteRequest request, bool accept) {
    FireStoreMethods.processInviteRequest(senderDocId, request, accept)
        .then((result) {
      setState(() {});
    });
  }

  Expanded requestIcon(String senderDocId, InviteRequest request) {
    return Expanded(
        flex: 6,
        child: Row(children: <Widget>[
          Expanded(
              child: IconButton(
                  icon: const Icon(Icons.done, color: Colors.green),
                  onPressed: () =>
                      {processInvite(senderDocId, request, true)})),
          Expanded(
              child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () =>
                      {processInvite(senderDocId, request, false)}))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
      const Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 48, bottom: 16),
            child: Text(
              "Invite requests",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          )),
      Padding(
          child: SegControl(
              nameLeft: 'Friends',
              nameRight: 'Teams',
              notifyParent: (bool right) => _switchSegment(right),
              rightActive: _rightSegment),
          padding: const EdgeInsets.only(bottom: 24)),
      FutureBuilder<dynamic>(
        future: FireStoreMethods.getCurrentUserRequests(
            AuthMethods().getUserUID(), _rightSegment),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "Something went wrong",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            if (snapshot.data[0]) {
              List<InviteRequest> unorderedInviteData = snapshot.data[1];
              QuerySnapshot<Map<String, dynamic>> senderSnapshot =
                  snapshot.data[2];
              List<String> adminNames = [];
              if (_rightSegment) {
                adminNames = snapshot.data[3];
              }
              print(adminNames);
              List<QueryDocumentSnapshot<Map<String, dynamic>>> senderDocs =
                  senderSnapshot.docs;
              int count = senderDocs.length;
              if (count == 0) {
                return const Text("No invites found",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
              }
              List<dynamic> senderData;
              if (_rightSegment) {
                senderData = senderDocs
                    .map((sender) => (Team.fromSnap(sender)))
                    .toList();
              } else {
                senderData = senderDocs
                    .map((sender) => (User.fromSnap(sender)))
                    .toList();
              }
              List<InviteRequest> inviteData = [];
              for (var i = 0; i < count; i++) {
                String searchedValue =
                    _rightSegment ? senderData[i].name : senderData[i].uid;
                for (var j = 0; j < unorderedInviteData.length; j++) {
                  if (unorderedInviteData[j].sender == searchedValue) {
                    inviteData.add(unorderedInviteData[j]);
                    break;
                  }
                }
              }
              return Expanded(
                  child: ListView.separated(
                itemCount: count,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                padding: const EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int index) {
                  return MemberList(
                      name: senderData[index].name,
                      image: senderData[index].avatarUrl != ""
                          ? NetworkImage(senderData[index].avatarUrl)
                          : null,
                      subtext: _rightSegment
                          ? TextSpan(
                              text: "\n" + adminNames[index].toTitleCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16))
                          : null,
                      rightIcon:
                          requestIcon(senderDocs[index].id, inviteData[index]));
                },
              ));
            } else {
              return Text(snapshot.data[1] as String,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold));
            }
          } else {
            return const Text("No invites found",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
          }
        },
      )
    ]));
  }
}
