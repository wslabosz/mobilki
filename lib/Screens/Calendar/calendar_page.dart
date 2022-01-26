import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Calendar/components/calendar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
          body: Calendar(),
        );
  }
}
