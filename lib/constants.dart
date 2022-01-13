import 'package:flutter/material.dart';

const orange = Color(0xffFFA450);
const darkOrange = Color(0xffED6436);
const black = Color(0xff000000);
const lightOrange = Color(0xffff7a00);
const grey = Color(0xffE8E8E8);
const lightGrey = Color(0xffc1c1c1);

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}