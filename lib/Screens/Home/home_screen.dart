import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/resources/firestore_methods.dart';
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FireStoreMethods.getEvents(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              if (snapshot.hasError) {
                return const Text('occurred error');
              } else if (snapshot.hasData) {
                return Body(
                    events: snapshot.data!.docs
                        .map((event) => (Event.fromSnap(event)))
                        .toList());
              } else {
                return const Text('no events');
              }
          }
        },
      ),
      bottomNavigationBar: const Navbar(index: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () => (Navigator.pushNamed(context, 'add')),
        backgroundColor: orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
