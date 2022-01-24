import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/components/event_tile.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/resources/firestore_methods.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then((value)=>FireStoreMethods.saveTokenToDatabase(value!));

    return _eventListView(context);
  }

  Widget _eventRowView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double avatarDiameter = size.width * 0.13;
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: size.width * 0.08,
              top: size.height * 0.012,
              bottom: size.height * 0.012),
          child: Container(
            width: avatarDiameter,
            height: avatarDiameter,
            decoration:
                const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(avatarDiameter / 2),
                child: Image.network(
                    'https://bi.im-g.pl/im/fd/2f/16/z23263741IER,Marcin-Najman.jpg')),
          ),
        ),
        _eventPlaceView(context),
        _eventDateView(context),
      ],
    );
  }

  Widget _eventPlaceView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding:
            EdgeInsets.only(left: size.width * 0.05, top: size.height * 0.002),
        child: Row(
          children: const [
            Text(
              'Boisko przy 4',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            )
          ],
        ),
      ),
      Padding(
        padding:
            EdgeInsets.only(left: size.width * 0.05, top: size.height * 0.002),
        child: Row(
          children: const [
            Text(
              'al. Politechniki 128',
              style: TextStyle(
                  color: lightGrey, fontSize: 16, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    ]);
  }

  Widget _eventDateView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Padding(
        padding:
            EdgeInsets.only(left: size.width * 0.085, top: size.height * 0.002),
        child: Row(
          children: const [
            Text(
              '18:00',
              style: TextStyle(
                  color: orange, fontWeight: FontWeight.w900, fontSize: 16),
            )
          ],
        ),
      ),
      Padding(
        padding:
            EdgeInsets.only(left: size.width * 0.085, top: size.height * 0.002),
        child: Row(
          children: const [
            Text('21-12-2021',
                style: TextStyle(
                    color: lightGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w900))
          ],
        ),
      ),
    ]);
  }

  Widget _eventView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _eventRowView(context),
      Divider(
        height: size.height * 0.025,
        thickness: 2,
        indent: size.width * 0.08,
        endIndent: size.width * 0.08,
        color: grey,
      )
    ]);
  }

  Widget _eventListView(BuildContext context) {
    Event testEvent=const Event(creator: "pqnZu9AaZqggyNBCBatP8FhLhfu2",title:"kocham mobilki mocno",location:GeoPoint(51.72142,19.41621),eventDate:'24-01-2022',participants:['XD'],level:2);
    return ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  padding: const EdgeInsets.all(8),
        itemCount: 30,
        itemBuilder: (context, index) {
          return EventTile(event:testEvent);
        });
  }
}
