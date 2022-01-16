import 'package:flutter/material.dart';

import 'package:mobilki/constants.dart';

// do wywalenia jak zostaną zrobione screeny

class Navbar extends StatelessWidget {
  final int index;
  const Navbar({Key? key, required this.index}) : super(key: key);

  static final _routeNames = [
    "home",
    "event",
    "add",
    "people",
    "search",
  ];

  static const _icons = [
    Icon(Icons.home),
    Icon(Icons.event),
    Icon(Icons.add_circle),
    Icon(Icons.people),
    Icon(Icons.search),
  ];

  static const _names = [
    "Ekran główny",
    "Spotkania",
    "Dodaj spotkanie",
    "Drużyny i znajomi",
    "Szukaj znajomych",
  ];

  void _onItemTapped(int index, BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).pushNamedAndRemoveUntil("/" + _routeNames[index],
          ModalRoute.withName("/" + _routeNames[index]));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> itemList = [];
    for (var i = 0; i < 5; i++) {
      itemList.add(BottomNavigationBarItem(icon: _icons[i], label: _names[i]));
    }
    return BottomNavigationBar(
      items: itemList,
      currentIndex: index,
      selectedItemColor: orange,
      unselectedItemColor: black,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      onTap: (details) => _onItemTapped(details, context),
    );
  }
}
