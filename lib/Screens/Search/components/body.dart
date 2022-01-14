import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/constants.dart';
import 'dart:developer';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class PopupMenuOptions {
  static const String firstItem = 'Dodaj do znajomych';
  static const String secondItem = 'Dodaj do drużyny';

  static const List<String> choices = <String>[
    firstItem,
    secondItem,
  ];
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  final TextEditingController _nameController = TextEditingController();
  String _search_value = "";

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();
    final FirebaseAuth auth = FirebaseAuth
        .instance;
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
                _search_value = value.toLowerCase();
              });
            },
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (_search_value.length < 3) {
                  return const SizedBox.shrink();
                }
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData) return const Text("No results found");
                var data = snapshot.data!.docs;
                data = data
                    .where((x) => (x['name'] as String).contains(_search_value))
                    .toList();
                var count = data.length;
                return Expanded(
                    child: ListView.separated(
                  itemCount: count,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                        height: 50,
                        child: Row(children: <Widget>[
                          Expanded(
                              flex: 4,
                              child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle, color: orange),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            (data[index]['name'][0] +
                                                    data[index]['name'][
                                                        (data[index]['name']
                                                                    as String)
                                                                .indexOf(' ') +
                                                            1] as String)
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 18))
                                      ]))),
                          Expanded(
                              flex: 13,
                              child: Text(
                                  ((data[index]['name']) as String)
                                      .toTitleCase(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18))),
                          Expanded(
                              flex: 3,
                              child: PopupMenuButton(
                                itemBuilder: (BuildContext context) {
                                  return PopupMenuOptions.choices
                                      .map((String choice) {
                                    return PopupMenuItem<String>(
                                        value: choice, child: Text(choice));
                                  }).toList();
                                },
                                icon: Icon(Icons.add),
                                onSelected: (choice) {
                                  if (choice == PopupMenuOptions.firstItem) {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc('KzWy3q03aJCjVTH52st1')
                                        .get()
                                        .then((result) {
                                      print(result['friends']);
                                      if ((result['friends'] as List)
                                          .contains(data[index]['uid'])) {
                                        Fluttertoast.showToast(
                                            msg: "User is already your friend");
                                      } else {
                                        FirebaseFirestore.instance
                                            .collection('invite_requests')
                                            .where('is_team', isEqualTo: false)
                                            .where('sender',
                                                isEqualTo:
                                                    'Sa2129lixvOZ1h7cl3iJe88ZLvF2')
                                            .where('receiver',
                                                isEqualTo: data[index]['uid'])
                                            .where('status', isEqualTo: 0)
                                            .get()
                                            .then((result) {
                                          if (result.docs.isEmpty) {
                                            FirebaseFirestore.instance
                                                .collection("invite_requests")
                                                .add({
                                              'is_team': false,
                                              'sender':
                                                  'Sa2129lixvOZ1h7cl3iJe88ZLvF2',
                                              'receiver': data[index]['uid'],
                                              'status': 0,
                                            });
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "User has pending invitation already");
                                          }
                                        });
                                      }
                                    });
                                    print('I First Item');
                                  } else if (choice ==
                                      PopupMenuOptions.secondItem) {
                                    CollectionReference teams =
                                        FirebaseFirestore.instance
                                            .collection('teams');
                                    showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder:
                                            (BuildContext context) =>
                                                AlertDialog(
                                                    title:
                                                        Text("Choose a team"),
                                                    content: FutureBuilder<
                                                        QuerySnapshot>(
                                                      future: teams
                                                          .where('admin_uid',
                                                              isEqualTo:
                                                                  'Sa2129lixvOZ1h7cl3iJe88ZLvF2')
                                                          .get(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                        if (snapshot.hasError) {
                                                          return const Text(
                                                              "Something went wrong");
                                                        }
                                                        if (snapshot.hasData) {
                                                          var teamData = snapshot
                                                              .data!.docs
                                                              .where((y) => !(y[
                                                                          'members']
                                                                      as List)
                                                                  .contains(data[
                                                                          index]
                                                                      ['uid']))
                                                              .toList();
                                                          inspect(teamData);

                                                          if (teamData
                                                              .isEmpty) {
                                                            return const Text(
                                                                "No teams found");
                                                          }
                                                          return Container(
                                                              width:
                                                                  size.width *
                                                                      0.8,
                                                              height:
                                                                  size.height *
                                                                      0.8,
                                                              child: ListView
                                                                  .builder(
                                                                itemCount:
                                                                    teamData
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index0) {
                                                                  return ListTile(
                                                                      title: Text((teamData[index0]
                                                                              [
                                                                              'name']
                                                                          as String)),
                                                                      onTap:
                                                                          () {
                                                                        CollectionReference
                                                                            invites =
                                                                            FirebaseFirestore.instance.collection("invite_requests");
                                                                        invites
                                                                            .where('is_team',
                                                                                isEqualTo: true)
                                                                            .where('sender', isEqualTo: teamData[index0]['name'])
                                                                            .where('receiver', isEqualTo: data[index]['uid'])
                                                                            .where('status', isEqualTo: 0)
                                                                            .get()
                                                                            .then((result) {
                                                                          if (result
                                                                              .docs
                                                                              .isEmpty) {
                                                                            FirebaseFirestore.instance
                                                                                .collection("invite_requests")
                                                                                .add({
                                                                                  'is_team': true,
                                                                                  'sender': teamData[index0]['name'],
                                                                                  'receiver': data[index]['uid'],
                                                                                  'status': 0,
                                                                                })
                                                                                .then((value) => Navigator.of(context, rootNavigator: true).pop('dialog'))
                                                                                .catchError((error) => print("Something went wrong"));
                                                                          } else {
                                                                            Fluttertoast.showToast(msg: "User has pending invitation already");
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
                                },
                              ))
                        ]));
                  },
                ));
              }),
          SizedBox(height: size.height * 0.03),
        ]));
  }
}
