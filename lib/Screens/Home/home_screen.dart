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
      body: FutureBuilder<List<Event>>(
        future: FireStoreMethods.getEvents(),
        builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
          switch (snapshot.connectionState) {
            // TODO: popracuj nad stanami
            case ConnectionState.waiting:
              return const Text('loading');
            default:
              if (snapshot.hasError) {
                return const Text('occurred error');
              } else if (snapshot.hasData) {
                return Body(
                  events: snapshot.data!,
                );
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
