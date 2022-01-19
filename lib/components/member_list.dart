import 'package:flutter/material.dart';
import 'package:mobilki/constants.dart';

class MemberList extends StatelessWidget {
  final String name;
  final Expanded rightIcon;
  final Expanded? text;
  final TextSpan? subtext;
  final NetworkImage? image;
  const MemberList(
      {Key? key, required this.name, required this.rightIcon, this.image, this.text, this.subtext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: Row(children: <Widget>[
          Expanded(
              flex: 4,
              child: CircleAvatar(
                  backgroundImage: image,
                  backgroundColor: orange,
                  child: image==null?Text(
                      (name[0] + (name.contains(' ')?name[name.indexOf(' ') + 1]:"")).toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)):null)),
          text ?? Expanded(
              flex: 13,
              child: RichText(text: TextSpan(text:name.toTitleCase(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),children:subtext != null?[subtext!]:null))),
          rightIcon
        ]));
  }
}
