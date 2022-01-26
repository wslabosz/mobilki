import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Event/event_screen.dart';
import 'package:mobilki/components/circle_avatar.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/resources/firestore_methods.dart';

class EventTile extends StatelessWidget {
  final Event event;
  const EventTile({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            FireStoreMethods.getEventFutureData(event.creator, event.location),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.hasError) {
            return const Text(
              "Something went wrong",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }
          List<String> snapshotData = snapshot.data!;
          String resolvedLocation = snapshotData[0];
          String avatarUrl = snapshotData[1];
          return InkWell(
              onTap: () => (Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => EventScreen(
                          event: event, locationName: resolvedLocation)))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 80,
                        child: Row(children: <Widget>[
                          Expanded(
                              flex: 4,
                              child: Avatar(
                                  image: avatarUrl == ""
                                      ? null
                                      : NetworkImage(avatarUrl),
                                  name: event.title)),
                          Expanded(
                              flex: 11,
                              child: RichText(
                                  text: TextSpan(
                                      text: event.title,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                      children: [
                                    TextSpan(
                                        text: "\n" + resolvedLocation,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 16,
                                            color: Colors.grey[600]))
                                  ]))),
                          Expanded(
                              flex: 5,
                              child: RichText(
                                  textAlign: TextAlign.right,
                                  text: TextSpan(
                                      text: event.eventDate.substring(11, 16),
                                      style: const TextStyle(
                                          color: orange,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                      children: [
                                        TextSpan(
                                            text: "\n" +
                                                event.eventDate
                                                    .substring(0, 10),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 16,
                                                color: Colors.grey[600]))
                                      ]))),
                          const Spacer()
                        ])),
                    SizedBox(
                        height: 20,
                        child: Row(children: <Widget>[
                          const Spacer(flex: 3),
                          const Expanded(
                              flex: 1,
                              child: Icon(Icons.sports_basketball,
                                  color: darkOrange)),
                          Expanded(
                              flex: 1,
                              child: Icon(Icons.sports_basketball,
                                  color: event.level > 1
                                      ? darkOrange
                                      : Colors.grey[400])),
                          Expanded(
                              flex: 1,
                              child: Icon(Icons.sports_basketball,
                                  color: event.level == 3
                                      ? darkOrange
                                      : Colors.grey[400])),
                          const Spacer(flex: 6),
                          Expanded(
                              flex: 2,
                              child: Text(
                                  event.participants.length.toString() + "/10",
                                  style: const TextStyle(
                                      color: darkOrange,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18))),
                          const Expanded(
                              flex: 1,
                              child: Icon(Icons.people, color: darkOrange)),
                          const Spacer(flex: 1)
                        ]))
                  ]));
        });
  }
}
