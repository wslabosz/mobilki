import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/models/event.dart';
import 'package:mobilki/resources/firestore_methods.dart';
import 'package:mobilki/resources/localization_methods.dart';
import 'package:mobilki/screens/Home/components/body.dart';
import 'package:mobilki/components/navbar.dart';
import 'package:mobilki/components/side_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GeoPoint? _userPosition;
  String? chosenLevel;
  DateTime? chosenDate;
  final TextEditingController _addressEditingController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    getUserPosition();
  }

  Future<void> _setChosenDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.orange, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.red, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2040));
    if (picked != null || picked != chosenDate) {
      setState(() {
        chosenDate = picked;
      });
    }
  }

  void getUserPosition() async {
    GeoPoint positon = await LocationMethods.determinePosition();
    setState(() {
      _userPosition = positon;
    });
  }

  void _setChosenLevel(String newLevel) {
    setState(() {
      if (newLevel != chosenLevel) {
        chosenLevel = newLevel;
      }
    });
  }

  void _setUserLocation(GeoPoint newLocation) {
    setState(() {
      if (newLocation != _userPosition) {
        _userPosition = newLocation;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBarWidget(),
      appBar: AppBar(
        title: const Text('Events'),
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
                      .toList(),
                  location: _userPosition,
                  addressEditingController: _addressEditingController,
                  chosenLevel: chosenLevel,
                  setChosenLevel: _setChosenLevel,
                  setUserLocation: _setUserLocation,
                  setChosenDate: _setChosenDate,
                  chosenDate: chosenDate,
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
