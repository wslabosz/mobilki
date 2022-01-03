import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonContainer(const Color(0xffFFA450), 'Register'),
        _buildButtonContainer(const Color(0xffED6436), 'Log in')
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StartScreen',
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              child: Image.asset(
                'assets/images/logo.png',
                semanticLabel: 'logo',
                width: 400,
                height: 280,
              ),
              height: 700,
              alignment: Alignment.center,
            ),
            buttonSection,
          ],
        ),
      ),
    );
  }

  Container _buildButtonContainer(Color color, String label) {
    return Container(
      width: 172,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.0),
        color: color,
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
