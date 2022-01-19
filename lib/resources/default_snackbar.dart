import 'package:flutter/material.dart';
import 'package:mobilki/constants.dart';

class Snackbars {
  static void defaultSnackbar(BuildContext context, String message,
      {SnackBarAction? action, bool positive = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white,fontSize:16,fontWeight: FontWeight.w500)),
        backgroundColor: positive == true ? darkOrange : Colors.red,
        action: action));
  }
}
