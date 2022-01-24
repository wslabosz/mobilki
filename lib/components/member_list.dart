import 'package:flutter/material.dart';
import 'package:mobilki/components/circle_avatar.dart';
import 'package:mobilki/constants.dart';

class MemberList extends StatelessWidget {
  final String name;
  final Expanded rightIcon;
  final Expanded? text;
  final TextSpan? subtext;
  final NetworkImage? image;
  final GestureTapCallback? inkWell;
  const MemberList(
      {Key? key,
      required this.name,
      required this.rightIcon,
      this.image,
      this.text,
      this.subtext,
      this.inkWell})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget textWidget = text ??
        RichText(
            text: TextSpan(
                text: name.toTitleCase(),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
                children: subtext != null ? [subtext!] : null));
    Widget avatar = Avatar(image: image, name: name);
    if (inkWell != null) {
      textWidget = InkWell(child: textWidget, onTap: inkWell);
      avatar = InkWell(child: avatar, onTap: inkWell);
    }
    textWidget = Expanded(flex: 13, child: textWidget);
    avatar = Expanded(flex: 4, child: avatar);
    return SizedBox(
        height: 50,
        child: Row(children: <Widget>[
          avatar,
          textWidget,
          rightIcon
        ]));
  }
}
