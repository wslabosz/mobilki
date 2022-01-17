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
    "search",
    "people",
    "invites",
  ];

  static const _icons = [
    Icon(Icons.home),
    Icon(Icons.event),
    Icon(Icons.add_circle),
    Icon(Icons.search),
    Icon(Icons.people),
    Icon(Icons.mark_email_unread),
  ];

  static const _names = [
    "Home",
    "Events",
    "Add event",
    "Search",
    "Teams and friends",
    "Invites",
  ];

  static const _visited = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  void _onItemTapped(int index, BuildContext context) {
    
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if(_visited[index]) {
      Navigator.of(context).pushNamedAndRemoveUntil("/" + _routeNames[index],
          ModalRoute.withName("/" + _routeNames[index]));
      }
      else {
        Navigator.of(context).pushNamed('/'+_routeNames[index]);
      }

    });
    print(1);
    _visited[index]=true;
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> itemList = [];
    for (var i = 0; i < 6; i++) {
      itemList.add(BottomNavigationBarItem(icon: _icons[i], label: _names[i]));
    }
    return BottomNavigationBar(
      type:BottomNavigationBarType.shifting,
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
