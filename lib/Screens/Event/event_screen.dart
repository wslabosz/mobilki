import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Event/components/body.dart';
import 'package:mobilki/models/event.dart';


class EventScreen extends StatelessWidget {
  final Event event;
  final String locationName;
  const EventScreen({Key? key, required this.event, required this.locationName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Body(event:event, locationName:locationName),
        );
  }
}
