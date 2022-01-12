import 'package:flutter/material.dart';
import 'package:mobilki/constants.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _eventListView();
  }

  Widget _eventRowView() {
    const double avatarDiameter = 50;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32.0, top: 10.0, bottom: 10.0),
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
        _eventPlaceView(),
        _eventDateView(),
      ],
    );
  }

  Widget _eventPlaceView() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 4.0),
        child: Row(
          children: [Text('Boisko przy 4', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),)],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 4.0),
        child: Row(
          children: [Text('al. Politechniki 128', style: TextStyle(color: lightGrey, fontSize: 16, fontWeight: FontWeight.w500),)],
        ),
      ),
    ]);
  }

  Widget _eventDateView() {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Padding(
        padding: const EdgeInsets.only(left: 26.0, top: 4.0),
        child: Row(
          children: [
            Text(
              '18:00',
              style: TextStyle(color: orange, fontWeight: FontWeight.w900, fontSize: 16),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 26.0, top: 4.0),
        child: Row(
          children: [Text('21-12-2021', style: TextStyle(color: lightGrey, fontSize: 16, fontWeight: FontWeight.w900))],
        ),
      ),
    ]);
  }

  Widget _eventView() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _eventRowView(),
      const Divider(
        height: 18,
        thickness: 2,
        indent: 28,
        endIndent: 24,
        color: grey,
      )
    ]);
  }

  Widget _eventListView() {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return _eventView();
        });
  }
}
