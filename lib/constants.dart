import 'package:flutter/material.dart';

const orange = Color(0xffFFA450);
const darkOrange = Color(0xffED6436);
const black = Color(0xff000000);
const lightOrange = Color(0xffff7a00);

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}