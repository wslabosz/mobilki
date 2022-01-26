import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobilki/Screens/Profile/profile_screen.dart';
import 'package:mobilki/components/action_text.dart';
import 'package:mobilki/components/event_details.dart';
import 'package:mobilki/components/member_list.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/models/user.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/default_snackbar.dart';
import 'package:mobilki/resources/firestore_methods.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  final Event event;
  final String locationName;
  const Body({Key? key, required this.event, required this.locationName})
      : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<User?> participantList = [null];
  late CameraPosition _cameraPosition;
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    _cameraPosition = CameraPosition(
        target: LatLng(
            widget.event.location.latitude, widget.event.location.longitude),
        zoom: 16);
    FirebaseFirestore.instance
        .collection('users')
        .where('events', arrayContains: widget.event.docId)
        .snapshots()
        .listen((snapshot) {
      participantList =
          snapshot.docs.map((doc) => (User.fromSnap(doc))).toList();
      setState(() {});
    });

    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  void addYourselfToEvent() {
    FireStoreMethods.addParticipant(
            widget.event.docId!, AuthMethods().getUserUID())
        .then((result) {
      Snackbars.defaultSnackbar(context, "You have joined the event",
          positive: true);
    });
  }

  void removeEvent({bool removeYourself = false}) {
    String dialogText = removeYourself
        ? "Removing yourself from event will remove whole event!"
        : "Are you sure you want to cancel the event?";
    String approveText =
        removeYourself ? "I understand, remove event" : "Remove event";
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
                title:
                    Text(dialogText, style: const TextStyle(color: Colors.red)),
                actions: [
                  TextButton(
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.red)),
                      onPressed: () => {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog')
                          }),
                  TextButton(
                      child: Text(approveText,
                          style: TextStyle(color: darkOrange)),
                      onPressed: () {
                        FireStoreMethods.deleteEvent(widget.event.docId!,
                                List<String>.from(widget.event.participants))
                            .then((result) {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                          Navigator.of(context, rootNavigator: true).pop();
                          Snackbars.defaultSnackbar(
                              context, "Event has been cancelled",
                              positive: true);
                        });
                      })
                ]));
  }

  void removeParticipant(String friend, {bool removeYourself = false}) {
    String dialogText = removeYourself
        ? "Are you sure that you want to leave the event"
        : "Are you sure that you want to remove that participant?";
    String approveText = removeYourself ? "Leave" : "Remove";
    String snackbarText = removeYourself
        ? "You have left the event"
        : "Participant removed sucessfully";
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text(dialogText),
              actions: [
                TextButton(
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.red)),
                    onPressed: () => {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog')
                        }),
                TextButton(
                  child: Text(approveText, style: TextStyle(color: darkOrange)),
                  onPressed: () {
                    FireStoreMethods.deleteParticipant(
                            widget.event.docId!, friend)
                        .then((value) {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      Snackbars.defaultSnackbar(context, snackbarText,
                          positive: true);
                    });
                  },
                )
              ],
            ));
  }

  Expanded removeIcon(String friend) {
    return Expanded(
        flex: 4,
        child: IconButton(
            icon: const Icon(Icons.remove, color: Colors.red),
            onPressed: () => {
                  ((friend == AuthMethods().getUserUID())
                      ? removeEvent(removeYourself: true)
                      : removeParticipant(friend))
                }));
  }

  Widget _participantList() {
    if (participantList.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text("Something went wrong!",
                  style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold))));
    }
    if (participantList[0] == null) {
      return const CircularProgressIndicator();
    }
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: participantList.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int index) {
        return MemberList(
            name: participantList[index]!.name,
            inkWell: () => (Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ProfileScreen(profile: participantList[index]!)))),
            image: participantList[index]!.avatarUrl != ""
                ? NetworkImage(participantList[index]!.avatarUrl)
                : null,
            rightIcon: (AuthMethods().getUserUID() == widget.event.creator)
                ? removeIcon(participantList[index]!.uid)
                : Expanded(child: Container()));
      },
    );
  }

  Widget determineAction() {
    String myUid = AuthMethods().getUserUID();
    print(widget.event.participants);
    print(myUid);
    if (myUid == widget.event.creator) {
      return ActionText(
          icon: const Icon(Icons.delete, color: Colors.red),
          text: "Delete event",
          color: Colors.red,
          action: () => (removeEvent()));
    } else if (participantList.any((user)=>(user!.uid==myUid))) {
      return ActionText(
          icon: const Icon(Icons.person_remove, color: Colors.red),
          text: "Leave event",
          color: Colors.red,
          action: () => (removeParticipant(myUid, removeYourself: true)));
    } else if (participantList.length < 10) {
      return ActionText(
          icon: const Icon(Icons.person_add, color: Colors.green),
          text: "Join event",
          color: Colors.green,
          action: () => (addYourselfToEvent()));
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: GoogleMap(
                  mapType: MapType.normal,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  markers: {
                    Marker(
                        markerId: MarkerId(widget.event.title),
                        position: LatLng(widget.event.location.latitude,
                            widget.event.location.longitude),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueOrange),
                        infoWindow: InfoWindow(
                            title: widget.locationName,
                            snippet: widget.event.title))
                  },
                  initialCameraPosition: _cameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  })),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView(
                primary: true,
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          widget.event.title,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      )),
                  (widget.event.team == null
                      ? const SizedBox(height: 0, width: 0)
                      : Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                widget.event.team!,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )))),
                  EventDetails(
                      event: widget.event,
                      locationName: widget.locationName,
                      noOfParticipants: participantList.length),
                  Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: determineAction()),
                  _participantList(),
                ],
              ))
        ]));
  }
}
