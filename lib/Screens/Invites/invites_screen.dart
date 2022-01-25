import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Invites/components/body.dart';
import 'package:mobilki/components/navbar.dart';

class InvitesScreen extends StatelessWidget {
  const InvitesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope (onWillPop: () async {return Navbar.navbarOnBack();}, child:const Scaffold(
      body: Body(),
      bottomNavigationBar: Navbar(index:3),
    ));
  }
}
