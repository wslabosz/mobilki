import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilki/Screens/Login/login_screen.dart';
import 'package:mobilki/resources/firestore_methods.dart';
import 'package:mobilki/screens/Home/components/body.dart';
import 'package:mobilki/components/navbar.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/components/side_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return Navbar.navbarOnBack();
        },
        child: Scaffold(
            drawer: SideBarWidget(),
            appBar: AppBar(
              title: const Text('Games'),
              /*leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => {
              AuthMethods().logout(),
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false)
            },
          )*/
            ),
            body: const Body(),
            bottomNavigationBar: const Navbar(index: 0)));
  }
}