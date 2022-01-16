import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/components/member_list.dart';

import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/default_snackbar.dart';

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
  static List<QueryDocumentSnapshot<Object?>> searchData = [];
  static List<QueryDocumentSnapshot<Object?>> teamData = [];

  void sendFriendRequest(int searchIndex) {
    String uid = AuthMethods().getUserUID();
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((result) {
      if ((result['friends'] as List)
          .contains(searchData[searchIndex]['uid'])) {
        Snackbars.defaultSnackbar(context, "User is already your friend",
            negative: true);
      } else {
        FirebaseFirestore.instance
            .collection('invite_requests')
            .where('is_team', isEqualTo: false)
            .where('sender', isEqualTo: uid)
            .where('receiver', isEqualTo: searchData[searchIndex]['uid'])
            .get()
            .then((result) {
          if (result.docs.isEmpty) {
            FirebaseFirestore.instance.collection("invite_requests").add({
              'is_team': false,
              'sender': uid,
              'receiver': searchData[searchIndex]['uid'],
            });
            Snackbars.defaultSnackbar(context, "Invitation sent succesfully!");
          } else {
            Snackbars.defaultSnackbar(
                context, "User has pending invitation already",
                negative: true);
          }
        });
      }
    });
  }

  void sendTeamRequest(int index0, int searchIndex) {
    CollectionReference invites =
        FirebaseFirestore.instance.collection("invite_requests");
    invites
        .where('is_team', isEqualTo: true)
        .where('sender', isEqualTo: teamData[index0]['name'])
        .where('receiver', isEqualTo: searchData[searchIndex]['uid'])
        .get()
        .then((result) {
      if (result.docs.isEmpty) {
        FirebaseFirestore.instance
            .collection("invite_requests")
            .add({
              'is_team': true,
              'sender': teamData[index0]['name'],
              'receiver': searchData[searchIndex]['uid'],
            })
            .then((value) =>
                Navigator.of(context, rootNavigator: true).pop('dialog'))
            .catchError((error) => Snackbars.defaultSnackbar(
                context, "Something went wrong",
                negative: true));
        Snackbars.defaultSnackbar(context, "Invitation sent succesfully!");
      } else {
        Snackbars.defaultSnackbar(
            context, "User has pending invitation already",
            negative: true);
      }
    });
  }

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

  void choiceAction(String choice, int searchIndex) {
    String uid = AuthMethods().getUserUID();
    if (choice == PopupMenuOptions.firstItem) {
      sendFriendRequest(searchIndex);
    } else if (choice == PopupMenuOptions.secondItem) {
      CollectionReference teams =
          FirebaseFirestore.instance.collection('teams');
      showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
              title: const Text("Choose a team"),
              actions: [
                TextButton(
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.red)),
                    onPressed: () => {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog')
                        })
              ],
              content: FutureBuilder<QuerySnapshot>(
                future: teams.where('admin_uid', isEqualTo: uid).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }
                  if (snapshot.hasData) {
                    var teamData = snapshot.data!.docs
                        .where((y) => !(y['members'] as List)
                            .contains(searchData[searchIndex]['uid']))
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
                                title: Text(
                                    (teamData[index0]['name'] as String),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                                onTap: () {
                                  sendTeamRequest(index0, searchIndex);
                                });
                          },
                        ));
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )));
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
                searchData = snapshot.data!.docs;
                searchData = searchData
                    .where((x) => (x['name'] as String).contains(_searchValue))
                    .toList();
                var count = searchData.length;
                return Expanded(
                    child: ListView.separated(
                  itemCount: count,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (BuildContext context, int index) {
                    return MemberList(
                        name: searchData[index]['name'],
                        image: searchData[index]['avatarUrl'] != ""
                            ? NetworkImage(searchData[index]['avatarUrl'])
                            : null,
                        rightIcon: popupMenu(index));
                  },
                ));
              }),
          SizedBox(height: size.height * 0.03),
        ]));
  }
}
