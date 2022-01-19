import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/components/member_list.dart';
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

class PopupMenuOptions {
  static const String firstItem = 'Add to friends';
  static const String secondItem = 'Add to team';

  static const List<String> choices = <String>[
    firstItem,
    secondItem,
  ];
}

class _BodyState extends State<Body> {
  static List<Team> teamData = [];
  static List<User> userData = [];

  Expanded popupMenu(int index) {
    return Expanded(
        flex: 3,
        child: PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return PopupMenuOptions.choices.map((String choice) {
                return PopupMenuItem<String>(
                    value: choice, child: Text(choice));
              }).toList();
            },
            icon: const Icon(Icons.add),
            onSelected: (String choice) {
              choiceAction(choice, index);
            }));
  }

  void teamDialog(int searchIndex) {
    String uid = AuthMethods().getUserUID();
    CollectionReference teams = FirebaseFirestore.instance.collection('teams');
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
            title: const Text("Choose a team"),
            actions: [
              TextButton(
                  child:
                      const Text("Cancel", style: TextStyle(color: Colors.red)),
                  onPressed: () => {
                        Navigator.of(context, rootNavigator: true).pop('dialog')
                      })
            ],
            content: FutureBuilder<QuerySnapshot>(
              future: teams.where('adminUid', isEqualTo: uid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }
                if (snapshot.hasData) {
                  teamData = snapshot.data!.docs
                      .where((y) => !(y['members'] as List)
                          .contains(userData[searchIndex].uid))
                      .map((y) => (Team.fromSnap(y)))
                      .toList();

                  if (teamData.isEmpty) {
                    return const Text("No teams found");
                  }
                  return Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.4,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: ListView.separated(
                        itemCount: teamData.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(indent: 8, endIndent: 8),
                        itemBuilder: (context, index0) {
                          return ListTile(
                              tileColor: darkOrange,
                              title: Text(teamData[index0].name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                              onTap: () {
                                FireStoreMethods.sendTeamRequest(teamData[index0].name, userData[searchIndex].uid).then((result) {
                                  Snackbars.defaultSnackbar(context,result[0],positive:result[1]);
                                  if(result[1]) {
                                    Navigator.of(context, rootNavigator: true).pop('dialog');
                                  }
                                });
                              });
                        },
                      ));
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )));
  }

  void choiceAction(String choice, int searchIndex) {
    if (choice == PopupMenuOptions.firstItem) { 
      FireStoreMethods.sendFriendRequest(AuthMethods().getUserUID(),userData[searchIndex].uid).then((value) => 
               Snackbars.defaultSnackbar(
            context, value[0],
            positive: value[1])
      
      );
    } else if (choice == PopupMenuOptions.secondItem) {
      teamDialog(searchIndex);
    }
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  final TextEditingController _nameController = TextEditingController();
  String _searchValue = "";

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: AuthMethods().getUserUID())
        .snapshots();
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 48),
                child: Text(
                  "Look for friends",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              )),
          SizedBox(height: size.height * 0.03),
          InputField(
            hintText: "Name",
            textEditingController: _nameController,
            textInputType: TextInputType.name,
            onChanged: (value) {
              setState(() {
                _searchValue = value.toLowerCase();
              });
            },
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (_searchValue.length < 3) {
                  return const SizedBox.shrink();
                }
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData) return const Text("No results found");
                List<QueryDocumentSnapshot<Object?>> searchData =
                    snapshot.data!.docs;
                userData = searchData
                    .where((x) => (x['name'] as String).contains(_searchValue))
                    .map((x) => (User.fromSnap(x)))
                    .toList();
                int count = userData.length;
                return Expanded(
                    child: ListView.separated(
                  itemCount: count,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (BuildContext context, int index) {
                    return MemberList(
                        name: userData[index].name,
                        image: userData[index].avatarUrl != ""
                            ? NetworkImage(userData[index].avatarUrl)
                            : null,
                        rightIcon: popupMenu(index));
                  },
                ));
              }),
        ]));
  }
}
