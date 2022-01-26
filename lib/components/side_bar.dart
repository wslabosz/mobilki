import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilki/Screens/Login/login_screen.dart';
import 'package:mobilki/components/circle_avatar.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/models/user.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/firestore_methods.dart';

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({Key? key}) : super(key: key);

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  String urlImage = "";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(AuthMethods().getUserUID())
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return const Drawer(child: Material(color: Colors.orange));
          }
          User userData = User.fromSnap(snapshot.data!);
          urlImage = userData.avatarUrl;
          return Drawer(
            child: Material(
              color: Colors.orange,
              child: ListView(
                children: <Widget>[
                  buildHeader(
                      urlImage: urlImage,
                      name: userData.name.toTitleCase(),
                      email: userData.email,
                      onClicked: () {
                        ImagePicker imagePicker = ImagePicker();
                        Future<XFile?> compressedImage = imagePicker.pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 200,
                            maxHeight: 200);
                        compressedImage.then((result) {
                          result?.readAsBytes().then((result) {
                            FireStoreMethods.uploadAvatar(
                                    result, AuthMethods().getUserUID())
                                .then((value) {
                              setState(() {
                                urlImage = value;
                              });
                            });
                          });
                        });
                      }),
                  Container(
                    padding: padding,
                    child: Column(
                      children: [
                        buildMenuItem(
                            text: 'Logout',
                            icon: Icons.logout,
                            onClicked: () => {
                                  AuthMethods().logout(),
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                      (route) => false)
                                }),
                        buildMenuItem(
                            text: "Your calendar",
                            icon: Icons.calendar_today,
                            onClicked: () =>
                                (Navigator.pushNamed(context, 'event')))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      Container(
        padding: padding
            .add(const EdgeInsets.only(top: 35)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                    onTap: onClicked,
                    child: Avatar(
                        radius: 40,
                        image: urlImage == "" ? null : NetworkImage(urlImage),
                        name: name))),
            SizedBox(
                height: 120,
                width: 160,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Text(
                      name,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    )),
                    Flexible(
                        child: Text(
                      email,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    )),
                  ],
                )),
          ],
        ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}
