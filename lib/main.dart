import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Start/start_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StartScreen',
        theme: ThemeData(
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)),
        home: const StartScreen());
  }
}
