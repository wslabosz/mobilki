import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobilki/components/event_tile.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/resources/firestore_methods.dart';

class Body extends StatelessWidget {
  final List<Event> events;
  final GeoPoint? location;
  const Body({
    Key? key,
    this.location,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (location != null) {
      events.sort((a, b) => Geolocator.distanceBetween(a.location.latitude,
              a.location.longitude, location!.latitude, location!.longitude)
          .compareTo(Geolocator.distanceBetween(b.location.latitude,
              b.location.longitude, location!.latitude, location!.longitude)));
    }
    Size size = MediaQuery.of(context).size;
    FirebaseMessaging.instance
        .getToken()
        .then((value) => FireStoreMethods.saveTokenToDatabase(value!));
    return Column(children: [
      Row(
        children: [
          Padding(
              padding: EdgeInsets.only(top: size.height * 0.02),
              child: InputField(
                  hintText: 'Address',
                  onChanged: (value) {},
                  textInputType: TextInputType.streetAddress,
                  textEditingController: TextEditingController()))
        ],
      ),
      Expanded(child: _eventListView(context, events))
    ]);
  }

  Widget _eventListView(BuildContext context, List<Event> events) {
    Size size = MediaQuery.of(context).size;
    return ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) => Divider(
              height: size.height * 0.025,
              thickness: 2,
              indent: size.width * 0.08,
              endIndent: size.width * 0.08,
              color: grey,
            ),
        padding: const EdgeInsets.all(8),
        itemCount: events.length,
        itemBuilder: (context, index) {
          if (index < events.length) {
            return EventTile(event: events[index]);
          } else if (events.length > index) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Center(child: Text('nothing more to load!')),
            );
          }
        });
  }
}
