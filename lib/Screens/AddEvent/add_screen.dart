import 'package:flutter/material.dart';
import 'package:mobilki/components/navbar.dart';
import 'components/add.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return Navbar.navbarOnBack();
        },
        child: const Scaffold(
          body: NewEventForm(),
          bottomNavigationBar: Navbar(index: 2),
        ));
  }
}
