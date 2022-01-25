import 'dart:collection';

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
  static final _visited = List.filled(6, false);
  static int _lastVisited = -1;

  static void init() {
    _visitedQueue.add(0);
    _visited[0] = true;
    _lastVisited = 0;
  }

  static Future<bool> navbarOnBack() async {
    final lastItem = _visitedQueue.last;
    _visitedQueue.removeLast();
    _visited[lastItem] = false;
    _lastVisited = _visitedQueue.last;
    return true;
  }

  static Queue<int> _visitedQueue = Queue<int>();

  void _onItemTapped(int index, BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_visited[index] == true) {
        while (_visitedQueue.last != index) {
          _visited[_visitedQueue.last] = false;

          _visitedQueue.removeLast();
        }

        Navigator.of(context).popUntil(ModalRoute.withName(_routeNames[index]));
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            _routeNames[index], ModalRoute.withName(_routeNames[_lastVisited]));
        _visitedQueue.add(index);
      }
      _visited[index] = true;
      _lastVisited = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> itemList = [];
    for (var i = 0; i < 6; i++) {
      itemList.add(BottomNavigationBarItem(icon: _icons[i], label: _names[i]));
    }
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
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

class NavbarVisited {}
