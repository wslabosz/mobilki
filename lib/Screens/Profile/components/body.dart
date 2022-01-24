import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilki/components/circle_avatar.dart';
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
  List<User?> memberList = [null];
  String avatarUrl = "";

  @override
  void initState() {
    super.initState();
        avatarUrl = widget.profile.avatarUrl;
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  Widget profileAvatar() {
    Widget avatar = Avatar(name:widget.profile.name,image:avatarUrl==""?null:NetworkImage(avatarUrl),radius:60,textSize:50);
    if(AuthMethods().getUserUID() == widget.profile.uid) {
      avatar = InkWell(child:avatar, onTap:() {
      ImagePicker imagePicker = ImagePicker();
      Future<XFile?> compressedImage = imagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 200, maxHeight: 200);
      compressedImage.then((result) {
        result?.readAsBytes().then((result) {
          FireStoreMethods()
              .uploadAvatar(result, widget.profile.uid)
              .then((value) {
            setState(() {
              print(value);
              avatarUrl=value;
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
              Padding(padding:const EdgeInsets.only(bottom:16),child:profileAvatar()),
              Text(
                  "Age "+widget.profile.getAge().toString(),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
        ]));
  }
}
