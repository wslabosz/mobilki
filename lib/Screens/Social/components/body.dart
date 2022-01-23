import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Team/team_screen.dart';
import 'package:mobilki/components/circle_avatar.dart';
import 'package:mobilki/components/member_list.dart';
import 'package:mobilki/components/segmeneted_control.dart';
import 'package:mobilki/components/team_tile.dart';
import 'package:mobilki/models/team.dart';
import 'package:mobilki/models/user.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/default_snackbar.dart';
import 'package:mobilki/resources/firestore_methods.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<User?> friendList = [null];
  List<Team?> teamList = [null];

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
    FirebaseFirestore.instance
        .collection('teams')
        .where('members', arrayContains: AuthMethods().getUserUID())
        .snapshots()
        .listen((snapshot) {
      teamList = snapshot.docs.map((doc) => (Team.fromSnap(doc))).toList();
      setState(() {});
    });

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

  void removeFriend(String friend) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                  "Are you sure that you want to remove that friend?"),
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
                    FireStoreMethods.deleteFriend(
                            AuthMethods().getUserUID(), friend)
                        .then((result) {
                      setState(() {});
                    });
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    Snackbars.defaultSnackbar(
                        context, "Friend has been removed",
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
            onPressed: () => {removeFriend(friend)}));
  }

  void viewTeamDetails() {}

  Future<Widget> _teamList() async {
    if (teamList.isEmpty) {
      return const Text("No friends found",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
    }
    if (teamList[0] == null) {
      return const CircularProgressIndicator();
    }
    List<List<Avatar>> avatars = [];
    for (var i = 0; i < teamList.length; i++) {
      QuerySnapshot<Map<String, dynamic>> teamMembersData =
          await FirebaseFirestore.instance
              .collection('users')
              .where('uid', whereIn: teamList[i]!.members)
              .get();
      List<User> teamMembers =
          teamMembersData.docs.map((member) => User.fromSnap(member)).toList();
      List<Avatar> tempAvatars = [];
      for (var j = 0; j < teamMembers.length; j++) {
        if (j == 3 && teamMembers.length > 4) {
          tempAvatars.add(Avatar(
              name: '+ ' + (teamMembers.length - 3).toString(),
              radius: 20,
              color: Colors.grey[700]));
          break;
        }
        tempAvatars.add(Avatar(
            name: teamMembers[j].name,
            image: teamMembers[j].avatarUrl != ""
                ? NetworkImage(teamMembers[j].avatarUrl)
                : null,
            radius: 20));
      }
      avatars.add(tempAvatars.reversed.toList());
    }
    return Expanded(
      child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: teamList.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 16);
          },
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () => (Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            TeamScreen(team: teamList[index]!)))),
                child: TeamTile(
                    teamName: teamList[index]!.name, avatars: avatars[index]));
          }),
    );
  }

  Widget _friendList() {
    if (friendList.isEmpty) {
      return const Text("No friends found",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
    }
    if (friendList[0] == null) {
      return const CircularProgressIndicator();
    }
    return Expanded(
        child: ListView.separated(
      itemCount: friendList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int index) {
        return MemberList(
            name: friendList[index]!.name,
            image: friendList[index]!.avatarUrl != ""
                ? NetworkImage(friendList[index]!.avatarUrl)
                : null,
            rightIcon: removeIcon(friendList[index]!.uid));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 48, bottom: 16),
                child: Text(
                  "Friends and teams",
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
          _rightSegment
              ? FutureBuilder(
                  future: _teamList(),
                  builder:
                      (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return snapshot.data!;
                  },
                )
              : _friendList()
        ]));
  }
}
