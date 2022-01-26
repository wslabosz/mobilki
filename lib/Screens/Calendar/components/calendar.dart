import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/firestore_methods.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat format = CalendarFormat.month;
  List<Event> events = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('events')
        .where('participants', arrayContains: AuthMethods().getUserUID())
        .where('eventDate',
            isGreaterThan:
                DateTime.now().add(const Duration(days: -30)).toString())
        .snapshots()
        .listen((snapshot) {
      events = snapshot.docs.map((doc) => (Event.fromSnap(doc))).toList();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        backgroundColor: Colors.orange,
      ),
      body: TableCalendar(
          focusedDay: DateTime.now(),
          firstDay: DateTime.now().add(const Duration(days: -30)),
          lastDay: DateTime(2050),
          calendarFormat: format,
          onFormatChanged: (CalendarFormat _format) {
            setState(() {
              format = _format;
            });
          }),
    );
  }
}
