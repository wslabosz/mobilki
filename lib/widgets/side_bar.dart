import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Login/login_screen.dart';
import 'package:mobilki/Screens/Settings/user_settings.dart';
import 'package:mobilki/resources/auth_methods.dart';

class SideBarWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    final name = 'Alicja Forysiak';
    final email = 'alicja.forysiak@gmail.com';
    final urlImage =
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80';

    return Drawer(
      child: Material(
        color: Colors.orange,
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsPage(
                  name: 'Sarah Abs',
                  urlImage: urlImage,
                ),
              )),
            ),
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
                                    builder: (context) => const LoginScreen()),
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
              CircleAvatar(radius: 40, backgroundImage: NetworkImage(urlImage)),
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

  /*void selectedItem(BuildContext context, int index) {
  Navigator.of(context).pop();
  switch (index) {
      case 0:
        onPressed: () => {
              AuthMethods().logout(),
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false)
            },
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const SettingsPage(),
        ));
        break;
    }
  }*/
}
