import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilki/components/circle_avatar.dart';
import 'package:mobilki/components/event_tile.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/models/user.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/firestore_methods.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  final User profile;
  const Body({Key? key, required this.profile}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Event?> eventList = [null];
  String avatarUrl = "";

  @override
  void initState() {
    super.initState();
    avatarUrl = widget.profile.avatarUrl;
    FirebaseFirestore.instance
        .collection('events')
        .where('participants', arrayContains: widget.profile.uid)
        .where('eventDate', isLessThanOrEqualTo: DateTime.now().toString())
        .orderBy('eventDate', descending: true)
        .limit(3)
        .snapshots()
        .listen((snapshot) {
      eventList = snapshot.docs.map((doc) => (Event.fromSnap(doc))).toList();
      setState(() {});
    });
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  Widget profileAvatar() {
    Widget avatar = Avatar(
        name: widget.profile.name,
        image: avatarUrl == "" ? null : NetworkImage(avatarUrl),
        radius: 60,
        textSize: 50);
    if (AuthMethods().getUserUID() == widget.profile.uid) {
      avatar = InkWell(
          child: avatar,
          onTap: () {
            ImagePicker imagePicker = ImagePicker();
            Future<XFile?> compressedImage = imagePicker.pickImage(
                source: ImageSource.gallery, maxWidth: 200, maxHeight: 200);
            compressedImage.then((result) {
              result?.readAsBytes().then((result) {
                FireStoreMethods
                    .uploadAvatar(result, widget.profile.uid)
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

    Widget _eventList() {
    if (eventList.isEmpty) {
    return const Padding(padding:EdgeInsets.only(top:16), child: Text("No event history found",
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

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 48, bottom: 16),
                child: Text(
                  widget.profile.name.toTitleCase(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: profileAvatar()),
          Text(
            "Age " + widget.profile.getAge().toString(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),_eventList()
        ]));
  }
}
