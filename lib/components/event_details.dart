import 'package:flutter/material.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/models/event.dart';

class EventDetails extends StatelessWidget {
  final Event event;
  final String locationName;
  final int noOfParticipants;
  const EventDetails(
      {Key? key, required this.event, required this.locationName, required this.noOfParticipants})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15),
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            primary: false,
            children: [
              EventDetailTile(name: "Location: ", detail: locationName),
              EventDetailTile(
                  name: "Date: ", detail: event.eventDate.substring(0, 10)),
              EventDetailTile(
                  name: "Time: ", detail: event.eventDate.substring(11, 16)),
              Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: EventIconGrid(
                      level: event.level,
                      participantCount: noOfParticipants.toString()))
            ]));
  }
}

class EventDetailTile extends StatelessWidget {
  final String name;
  final String detail;
  const EventDetailTile({Key? key, required this.name, required this.detail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Flexible(
            child: Text(name,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800]))),
        Flexible(
            child: Text(detail,
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
      ]),
    );
  }
}

class EventIconGrid extends StatelessWidget {
  final String participantCount;
  final int level;
  const EventIconGrid(
      {Key? key, required this.level, required this.participantCount})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Level",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800])),
            EventDetailLevelIcons(level: level)
          ]),
      Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("Participants",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800])),
            EventDetailParticipantIcon(participantCount: participantCount)
          ])
    ]);
  }
}

class EventDetailLevelIcons extends StatelessWidget {
  final int level;
  const EventDetailLevelIcons({Key? key, required this.level})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Icon(Icons.sports_basketball, color: darkOrange),
      Icon(Icons.sports_basketball,
          color: level > 1 ? darkOrange : Colors.grey[400]),
      Icon(Icons.sports_basketball,
          color: level == 3 ? darkOrange : Colors.grey[400])
    ]);
  }
}

class EventDetailParticipantIcon extends StatelessWidget {
  final String participantCount;
  const EventDetailParticipantIcon({Key? key, required this.participantCount})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(participantCount + "/10",
          style: const TextStyle(
              color: darkOrange, fontWeight: FontWeight.w600, fontSize: 18)),
      const Icon(Icons.people, color: darkOrange),
    ]);
  }
}
