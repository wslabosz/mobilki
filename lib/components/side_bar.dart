import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilki/Screens/Login/login_screen.dart';
import 'package:mobilki/Screens/Settings/user_settings.dart';
import 'package:mobilki/components/circle_avatar.dart';
import 'package:mobilki/models/user.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/firestore_methods.dart';

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({Key? key}) : super(key: key);

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 20);
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
          User userData = User.fromSnap(snapshot.data!);
          urlImage = userData.avatarUrl;
          return Drawer(
            child: Material(
              color: Colors.orange,
              child: ListView(
                children: <Widget>[
                  buildHeader(
                      urlImage: urlImage,
                      name: userData.name,
                      email: userData.email,
                      onClicked: () {
                        ImagePicker imagePicker = ImagePicker();
                        Future<XFile?> compressedImage = imagePicker.pickImage(
                            source: ImageSource.gallery, imageQuality: 66);
                        compressedImage.then((result) {
                          result?.readAsBytes().then((result) {
                            FireStoreMethods().uploadAvatar(
                                result, AuthMethods().getUserUID()).then((value) {
                                  setState(() {
                                    urlImage=value;
                                  });
                                });
                          });
                        });
                      }),
                  Container(
                    padding: padding,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        buildMenuItem(
                            text: 'Wyloguj',
                            icon: Icons.logout,
                            onClicked: () => {
                                  AuthMethods().logout(),
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                      (route) => false)
                                }),
                        /*const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Wyloguj',
                    icon: Icons.logout,
                    onClicked: () => selectedItem(context, 1),
                  ),*/
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
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding
              .add(const EdgeInsets.symmetric(vertical: 50, horizontal: 5)),
          child: Row(
            children: [
              Avatar(radius: 40, image: NetworkImage(urlImage),name:name),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
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
