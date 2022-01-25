import 'package:flutter/material.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/screens/Home/components/body.dart';
import 'package:mobilki/components/navbar.dart';
import 'package:mobilki/components/side_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBarWidget(),
      appBar: AppBar(
        title: const Text('Games'),
        backgroundColor: Colors.orange,
      ),
      body: const Body(),
      bottomNavigationBar: Navbar(index: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () => (Navigator.pushNamed(context, 'add')),
        backgroundColor: orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
