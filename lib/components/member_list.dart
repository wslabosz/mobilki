import 'package:flutter/material.dart';
import 'package:mobilki/constants.dart';

class MemberList extends StatelessWidget {
  final String name;
  final Expanded rightIcon;
  final MemoryImage? image;
  const MemberList(
      {Key? key, required this.name, required this.rightIcon, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: Row(children: <Widget>[
          Expanded(
              flex: 4,
              child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: orange),
                  child: image != null
                      ? null
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              Text(
                                  (name[0] +
                                      name[name.indexOf(' ') + 1]).toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18))
                            ]))),
          Expanded(
              flex: 13,
              child: Text(name.toTitleCase(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18))),
          rightIcon
        ]));
  }
}
