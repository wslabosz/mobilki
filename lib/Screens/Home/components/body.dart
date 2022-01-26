import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/components/event_tile.dart';
import 'dart:math';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/resources/firestore_methods.dart';

class Body extends StatefulWidget {
  final List<Event> events;
  const Body({
    Key? key,
    required this.events,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  ScrollController _scrollController = ScrollController();
  int _currentIndexOfLastEvent = 6;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
            _currentIndexOfLastEvent < widget.events.length) {
          _showMoreEvents();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _showMoreEvents() {
    setState(() {
      _currentIndexOfLastEvent = _currentIndexOfLastEvent + 6;
    });
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance
        .getToken()
        .then((value) => FireStoreMethods.saveTokenToDatabase(value!));
    return _eventListView(context, widget.events);
  }

  Widget _eventListView(BuildContext context, List<Event> events) {
    return ListView.separated(
        controller: _scrollController,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        padding: const EdgeInsets.all(8),
        itemCount: min(_currentIndexOfLastEvent, events.length),
        itemBuilder: (context, index) {
          return EventTile(event: events[index]);
        });
  }
}
