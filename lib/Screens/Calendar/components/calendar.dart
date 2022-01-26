import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Calendar/components/utils.dart';
import 'package:mobilki/components/event_tile.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat format = CalendarFormat.month;
  List<Event> events = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('events')
        .orderBy('eventDate')
        .where('participants', arrayContains: AuthMethods().getUserUID())
        .where('eventDate',
            isGreaterThan:
                DateTime.now().add(const Duration(days: -30)).toString())
        .snapshots()
        .listen((snapshot) {
      events = snapshot.docs.map((doc) => (Event.fromSnap(doc))).toList();
      setState(() {});
    });

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Calendar"),
          backgroundColor: Colors.orange,
        ),
        body: Column(
          children: [
            TableCalendar<Event>(
                locale: 'en_US',
                focusedDay: _focusedDay,
                eventLoader: _getEventsForDay,
                firstDay: DateTime.now().add(const Duration(days: -30)),
                lastDay: DateTime(2150),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  _onDaySelected(selectedDay);
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                // ignore: prefer_const_constructors
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                      color: Colors.orangeAccent, shape: BoxShape.circle),
                  // ignore: prefer_const_constructors
                  todayDecoration: BoxDecoration(
                      color: Colors.deepOrangeAccent, shape: BoxShape.circle),
                ),
                calendarFormat: format,
                onFormatChanged: (CalendarFormat _format) {
                  setState(() {
                    format = _format;
                  });
                }),
            const SizedBox(height: 8.0),
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      padding: const EdgeInsets.all(8),
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return EventTile(event: value[index]);
                      });
                },
              ),
            ),
          ],
        ));
  }

  List<Event> _getEventsForDay(DateTime day) {
    final groupedByDate = UtilsCalendar.groupBy(
        events, (Event event) => (event.eventDate.substring(0, 10)));
    final _kEventSource = {
      for (var key in groupedByDate.keys)
        DateTime.parse(key): groupedByDate[key] ?? []
    };
    final kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSource);
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
      print(_selectedEvents.value);
    }
  }

  static int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
}
