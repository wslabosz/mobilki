import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Calendar/components/calendar.dart';
import 'package:mobilki/components/navbar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return Navbar.navbarOnBack();
        },
        child: const Scaffold(
          body: Calendar(),
          bottomNavigationBar: Navbar(index: 1),
        ));
  }
}
