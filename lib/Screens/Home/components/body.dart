import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobilki/components/day_picker.dart';
import 'package:mobilki/components/event_tile.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/resources/firestore_methods.dart';

class Body extends StatelessWidget {
  final List<Event> events;
  final GeoPoint? location;
  final void Function(GeoPoint) setUserLocation;
  final TextEditingController addressEditingController;
  final String? chosenLevel;
  final void Function(String) setChosenLevel;
  final DateTime? chosenDate;
  final Future<void> Function(BuildContext) setChosenDate;
  const Body(
      {Key? key,
      this.location,
      required this.setUserLocation,
      required this.events,
      required this.addressEditingController,
      required this.chosenLevel,
      required this.setChosenLevel,
      required this.chosenDate,
      required this.setChosenDate})
      : super(key: key);

  void onSubmitAddress(String address) async {
    List<Location> location = await locationFromAddress(address);
    // nie mam zamiaru sie zastanawiac nad ta lista, biore pierwszy element
    setUserLocation(GeoPoint(location[0].latitude, location[0].longitude));
  }

  List<Event> sortEvents(
      GeoPoint? locationToDetermine, String? level, DateTime? chosenDate) {
    List<Event> sortedEvents = events;

    if (chosenDate != null) {
      sortedEvents = sortedEvents
          .where(
              (e) => DateTime.parse(e.eventDate.substring(0, 10)) == chosenDate)
          .toList();
    }
    switch (level) {
      case 'Beginner':
        sortedEvents = sortedEvents.where((e) => e.level == 1).toList();
        break;
      case 'Advanced':
        sortedEvents = sortedEvents.where((e) => e.level == 2).toList();
        break;
      case 'Professional':
        sortedEvents = sortedEvents.where((e) => e.level == 3).toList();
        break;
      default:
        break;
    }
    if (locationToDetermine != null) {
      sortedEvents.sort((a, b) => Geolocator.distanceBetween(
              a.location.latitude,
              a.location.longitude,
              locationToDetermine.latitude,
              locationToDetermine.longitude)
          .compareTo(Geolocator.distanceBetween(
              b.location.latitude,
              b.location.longitude,
              locationToDetermine.latitude,
              locationToDetermine.longitude)));
    }

    return sortedEvents;
  }

  @override
  Widget build(BuildContext context) {
    if (location != null) {
      sortEvents(location!, chosenLevel, chosenDate);
    }
    Size size = MediaQuery.of(context).size;
    FirebaseMessaging.instance
        .getToken()
        .then((value) => FireStoreMethods.saveTokenToDatabase(value!));
    return Center(
        child: Column(children: [
      Row(children: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.02,
                    left: size.width * 0.08,
                    right: size.width * 0.1),
                child: InputField(
                  hintText: 'Address',
                  onChanged: (value) {},
                  inputAction: TextInputAction.search,
                  textInputType: TextInputType.streetAddress,
                  textEditingController: addressEditingController,
                  onSubmitFunction: onSubmitAddress,
                )))
      ]),
      Row(children: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.08, right: size.width * 0.02),
                child: DateDayPicker(
                  date: chosenDate,
                  selectDate: setChosenDate,
                ))),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(
                    right: size.width * 0.10, left: size.width * 0.02),
                child: DropdownButton<String>(
                  hint: const Text("Proficency level"),
                  value: chosenLevel,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: black),
                  underline: Container(
                    height: 2,
                    color: orange,
                  ),
                  onChanged: (String? newValue) {
                    setChosenLevel(newValue!);
                    sortEvents(location!, chosenLevel, chosenDate);
                  },
                  items: <String>['Any', 'Beginner', 'Advanced', 'Professional']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )))
      ]),
      Expanded(
          child: _eventListView(
              context, sortEvents(location, chosenLevel, chosenDate)))
    ]));
  }

  Widget _eventListView(BuildContext context, List<Event> events) {
    Size size = MediaQuery.of(context).size;
    return ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int index) => Divider(
              height: size.height * 0.025,
              thickness: 2,
              indent: size.width * 0.04,
              endIndent: size.width * 0.04,
              color: grey,
            ),
        padding: const EdgeInsets.only(left: 8, right: 8),
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
