import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Invites/components/body.dart';
import 'package:mobilki/components/navbar.dart';

class InvitesScreen extends StatelessWidget {
  const InvitesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return Navbar.navbarOnBack();
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Events'),
            backgroundColor: Colors.orange,
          ),
          body: const Body(),
          bottomNavigationBar: const Navbar(index: 3),
        ));
  }
}
