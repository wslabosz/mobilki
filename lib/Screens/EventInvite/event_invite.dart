import 'package:flutter/material.dart';
import 'package:mobilki/Screens/EventInvite/components/body.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/models/user.dart';

class EventInvite extends StatelessWidget {
  final Event event;
  final List<User> participantList;
  const EventInvite({Key? key, required this.event, required this.participantList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Invite friend'),
            backgroundColor: Colors.orange,
          ),
          body: Body(event:event, participantList: participantList),
        );
  }
}
