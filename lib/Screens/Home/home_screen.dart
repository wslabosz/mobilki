import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Home/components/body.dart';
import 'package:mobilki/components/navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: Body(), 
      bottomNavigationBar: Navbar(index: 0)
    );
  }
}
