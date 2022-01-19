import 'package:flutter/material.dart';
import 'package:mobilki/constants.dart';

class Avatar extends StatelessWidget {
  final String name;
  final NetworkImage? image;
  final double? radius;
  const Avatar(
      {Key? key, required this.name, this.image, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
                  backgroundImage: image,
                  backgroundColor: orange,
                  child: image==null?Text((name[0] + (name.contains(' ')?name[name.indexOf(' ') + 1]:"")).toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)):null,
                          radius:radius);
  }
}
