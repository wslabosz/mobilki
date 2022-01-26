import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilki/Screens/Profile/profile_screen.dart';
import 'package:mobilki/components/circle_avatar.dart';
import 'package:mobilki/components/event_tile.dart';
import 'package:mobilki/components/member_list.dart';
import 'package:mobilki/components/segmeneted_control.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/models/team.dart';
import 'package:mobilki/models/user.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/default_snackbar.dart';
import 'package:mobilki/resources/firestore_methods.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  final Team team;
  const Body({Key? key, required this.team}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<User?> memberList = [null];
  List<Event?> eventList = [null];
  String avatarUrl = "";

  @override
  void initState() {
    super.initState();
    avatarUrl = widget.team.avatarUrl;
    FirebaseFirestore.instance
        .collection('users')
        .where('teams', arrayContains: widget.team.name)
        .snapshots()
        .listen((snapshot) {
      memberList = snapshot.docs.map((doc) => (User.fromSnap(doc))).toList();
      setState(() {});
    });
      FirebaseFirestore.instance
        .collection('events')
        .where('team', isEqualTo: widget.team.name)
        .where('eventDate',isGreaterThanOrEqualTo:DateTime.now().toString())
        .orderBy('eventDate')
        .snapshots()
        .listen((snapshot) {
      eventList = snapshot.docs.map((doc) => (Event.fromSnap(doc))).toList();
      setState(() {});
    });


  }

  bool _rightSegment = false;

  void _switchSegment(bool right) {
    setState(() {
      _rightSegment = right;
    });
  }

  void removeTeam() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
                title: const Text(
                    "Removing yourself from team will remove whole team!",
                    style: TextStyle(color: Colors.red)),
                actions: [
                  TextButton(
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.red)),
                      onPressed: () => {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog')
                          }),
                  TextButton(
                      child: const Text('I understand, remove team',
                          style: TextStyle(color: darkOrange)),
                      onPressed: () {
                        FireStoreMethods.deleteTeam(
                                widget.team.uid!,
                                widget.team.name,
                                List<String>.from(widget.team.members))
                            .then((result) {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                          Navigator.of(context, rootNavigator: true).pop();
                          Snackbars.defaultSnackbar(
                              context, "Team has been removed",
                              positive: true);
                        });
                      })
                ]));
  }

  void removeMember(String friend) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                  "Are you sure that you want to remove that member?"),
              actions: [
                TextButton(
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.red)),
                    onPressed: () => {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog')
                        }),
                TextButton(
                  child:
                      const Text('Remove', style: TextStyle(color: darkOrange)),
                  onPressed: () {
                    FireStoreMethods.deleteMember(widget.team.name, friend)
                        .then((result) {
                      setState(() {});
                    });
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    Snackbars.defaultSnackbar(
                        context, "Member has been removed",
                        positive: true);
                  },
                )
              ],
            ));
  }

  Expanded removeIcon(String friend) {
    return Expanded(
        flex: 4,
        child: IconButton(
            icon: const Icon(Icons.person_remove, color: Colors.red),
            onPressed: () => {
                  ((friend == AuthMethods().getUserUID())
                      ? removeTeam()
                      : removeMember(friend))
                }));
  }

  Widget _memberList() {
    if (memberList.isEmpty) {
      return const Text("No members found",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
    }
    if (memberList[0] == null) {
      return const CircularProgressIndicator();
    }
    return Expanded(
        child: ListView.separated(
      itemCount: memberList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int index) {
        return MemberList(
            name: memberList[index]!.name,
            inkWell: () => (Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ProfileScreen(profile: memberList[index]!)))),
            image: memberList[index]!.avatarUrl != ""
                ? NetworkImage(memberList[index]!.avatarUrl)
                : null,
            rightIcon: (AuthMethods().getUserUID() == widget.team.adminUid)
                ? removeIcon(memberList[index]!.uid)
                : Expanded(child: Container()));
      },
    ));
  }

    Widget _eventList() {
    if (eventList.isEmpty) {
    return const Padding(padding:EdgeInsets.only(top:16), child: Text("No events found",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)));
    }
    if (eventList[0] == null) {
      return const CircularProgressIndicator();
    }
    return Expanded(
        child: ListView.separated(
      itemCount: eventList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int index) {
        return EventTile(event: eventList[index]!);
      },
    ));
  }

  Widget teamAvatar() {
    Widget avatar = Avatar(
            name: widget.team.name,
            image: avatarUrl == "" ? null : NetworkImage(avatarUrl),
            radius: 60,
            textSize: 50);
    if(AuthMethods().getUserUID() == widget.team.adminUid) {
      avatar = InkWell(child:avatar, onTap:() {
                ImagePicker imagePicker = ImagePicker();
                Future<XFile?> compressedImage = imagePicker.pickImage(
                    source: ImageSource.gallery, maxWidth: 200, maxHeight: 200);
                compressedImage.then((result) {
                  result?.readAsBytes().then((result) {
                    FireStoreMethods
                        .uploadAvatar(result, widget.team.uid!,
                            collection: 'teams')
                        .then((value) {
                      setState(() {
                        print(value);
                        avatarUrl = value;
                      });
                    });
                  });
                });
              });
    }
    return avatar;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
      Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 48, bottom: 16),
            child: Text(
              widget.team.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          )),
      Padding(padding: const EdgeInsets.only(bottom: 16), child: teamAvatar()),
      Padding(
          child: SegControl(
              nameLeft: 'Members',
              nameRight: 'Events',
              notifyParent: (bool right) => _switchSegment(right),
              rightActive: _rightSegment),
          padding: const EdgeInsets.only(bottom: 24)),
      _rightSegment ? _eventList() : _memberList()
    ]));
  }
}
