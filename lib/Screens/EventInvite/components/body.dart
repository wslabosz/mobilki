import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/components/member_list.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/models/user.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/default_snackbar.dart';
import 'package:mobilki/resources/firestore_methods.dart';


class Body extends StatefulWidget {
  final Event event;
  final List<User> participantList;
  const Body({Key? key, required this.event, required this.participantList})
      : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<User?> friendList = [null];
  String avatarUrl = "";

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .where('friends', arrayContains: AuthMethods().getUserUID())
        .snapshots()
        .listen((snapshot) {
      friendList = snapshot.docs.map((doc) => (User.fromSnap(doc))).toList();
      setState(() {});
    });
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  void addFriendToEvent(String friendUID) {
    FireStoreMethods.addParticipant(widget.event.docId!, friendUID)
        .then((result) {
      Snackbars.defaultSnackbar(context, "Friend invited succesfully",
          positive: true);
      Navigator.pop(context);
    });
  }

  Widget _friendList() {
    if (friendList.isEmpty) {
      return const Padding(
          padding: EdgeInsets.only(top: 32),
          child: Text("No friends available to nvite",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
    }
    if (friendList[0] == null) {
      return const CircularProgressIndicator();
    }
    List<String> participantIds =
        widget.participantList.map((user) => user.uid).toList();
    List<User?> newFriendList = (widget.event.team == null
        ? friendList.where((x) => !participantIds.contains(x!.uid)).toList()
        : friendList
            .where((x) => (x!.teams.contains(widget.event.team) &&
                !participantIds.contains(x.uid)))
            .toList());
    if (newFriendList.isEmpty) {
      return const Padding(
          padding: EdgeInsets.only(top: 32),
          child: Text("No friends available to invite",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
    }
    return Expanded(
        child: ListView.separated(
      itemCount: newFriendList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int index) {
        return MemberList(
            name: newFriendList[index]!.name,
            image: newFriendList[index]!.avatarUrl == ""
                ? null
                : NetworkImage(newFriendList[index]!.avatarUrl),
            inkWell: () => addFriendToEvent(newFriendList[index]!.uid),
            rightIcon: const Expanded(child: SizedBox.shrink()));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_friendList()]));
  }
}
