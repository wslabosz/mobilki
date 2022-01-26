import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobilki/Screens/Profile/profile_screen.dart';
import 'package:mobilki/components/circle_avatar.dart';
import 'package:mobilki/components/event_details.dart';
import 'package:mobilki/components/event_tile.dart';
import 'package:mobilki/components/member_list.dart';
import 'package:mobilki/components/segmeneted_control.dart';
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

  void removeTeam() {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
                title: const Text(
                    "Removing yourself from team will remove whole team!",
                    style: TextStyle(color: Colors.red)),
                actions: [
                  TextButton(
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.red)),
                      onPressed: () => {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog')
                          }),
                  TextButton(
                      child: const Text('I understand, remove team',
                          style: TextStyle(color: darkOrange)),
                      onPressed: () {})
                ]));
  }

  void removeMember(String friend) {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: const Text(
                  "Are you sure that you want to remove that member?"),
              actions: [
                TextButton(
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.red)),
                    onPressed: () => {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog')
                        }),
                TextButton(
                  child:
                      const Text('Remove', style: TextStyle(color: darkOrange)),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    Snackbars.defaultSnackbar(
                        context, "Member has been removed",
                        positive: true);
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
                      ? removeTeam()
                      : removeMember(friend))
                }));
  }

  Widget _participantList() {
    if (participantList.isEmpty) {
      return const Text("No participants found",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
    }
    if (participantList[0] == null) {
      return const CircularProgressIndicator();
    }
    return ListView.separated(
          physics:const NeverScrollableScrollPhysics(),
      shrinkWrap:true,
      itemCount: 10,
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      padding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int index) {
        return MemberList(
            name: participantList[0]!.name,
            inkWell: () => (Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ProfileScreen(profile: participantList[0]!)))),
            image: participantList[0]!.avatarUrl != ""
                ? NetworkImage(participantList[0]!.avatarUrl)
                : null,
            rightIcon: (AuthMethods().getUserUID() == widget.event.creator)
                ? removeIcon(participantList[0]!.uid)
                : Expanded(child: Container()));
      },
    );
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
          SizedBox(height:MediaQuery.of(context).size.height*0.7,child:ListView(
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
                      : Align( alignment:Alignment.topCenter, child:Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            widget.event.team!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )))),
                  EventDetails(
                      event: widget.event, locationName: widget.locationName),
                  Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: _participantList())
                ],
              ))
        ]));
  }
}
