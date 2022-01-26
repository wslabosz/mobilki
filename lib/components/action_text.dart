import 'package:flutter/material.dart';
import 'package:mobilki/components/circle_avatar.dart';
import 'package:mobilki/constants.dart';

class ActionText extends StatelessWidget {
  final String text;
  final Icon icon;
  final Color color;
  final void Function() action;
  const ActionText(
      {Key? key,
      required this.text,
      required this.icon,
      this.color = darkOrange,
      required this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: action,
        child: RichText(
            text: TextSpan(children: [
          TextSpan(text: text, style: TextStyle(fontSize: 28, color: color)),WidgetSpan(child: icon)
        ])));
  }
}
