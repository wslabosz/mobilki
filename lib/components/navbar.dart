import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mobilki/constants.dart';
import 'package:mobilki/models/invite_request.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:mobilki/resources/default_snackbar.dart';

// do wywalenia jak zostaną zrobione screeny

class Navbar extends StatefulWidget {
  final int index;
  bool invitesPending = false;
  Navbar({Key? key, required this.index}) : super(key: key);

  static final _routeNames = [
    "home",
    "search",
    "people",
    "invites",
  ];

  static const _names = [
    "Home",
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

  static final Queue<int> _visitedQueue = Queue<int>();

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  static final Stream inviteStream = FirebaseFirestore.instance
      .collection('invite_requests')
      .where('receiver', isEqualTo: AuthMethods().getUserUID())
      .limit(1)
      .snapshots();
  static late StreamSubscription inviteListener;
  @override
  void initState() {
    super.initState();
    inviteListener = inviteStream.listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        print(1);
        print(widget.invitesPending);
        setState(() {
          widget.invitesPending = false;
        });
      } else {
        print(2);
        print(widget.invitesPending);
        if(widget.invitesPending==false) {
          setState(() {
            widget.invitesPending = true;
          });
          Snackbars.defaultSnackbar(context, "You have a new invitation!");
        }

      }
    });
    setState(() {});
  }

  void _onItemTapped(int index, BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (Navbar._visited[index] == true) {
        while (Navbar._visitedQueue.last != index) {
          Navbar._visited[Navbar._visitedQueue.last] = false;

          Navbar._visitedQueue.removeLast();
        }

        Navigator.of(context)
            .popUntil(ModalRoute.withName(Navbar._routeNames[index]));
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(Navbar._routeNames[index],
            ModalRoute.withName(Navbar._routeNames[Navbar._lastVisited]));
        Navbar._visitedQueue.add(index);
      }
      Navbar._visited[index] = true;
      Navbar._lastVisited = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.invitesPending);
    List<Widget> _icons = [
      const Icon(Icons.home),
      const Icon(Icons.search),
      const Icon(Icons.people),
      widget.invitesPending
          ? Stack(children: const <Widget>[
              Icon(Icons.email),
              Positioned(
                // draw a red marble
                top: 0.0,
                right: -1.0,
                child: Icon(Icons.brightness_1, size: 14.0, color: orange),
              )
            ])
          : const Icon(Icons.email),
    ];
    List<BottomNavigationBarItem> itemList = [];
    for (var i = 0; i < 4; i++) {
      itemList.add(
          BottomNavigationBarItem(icon: _icons[i], label: Navbar._names[i]));
    }
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: itemList,
      currentIndex: widget.index,
      selectedItemColor: orange,
      unselectedItemColor: black,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      onTap: (details) => _onItemTapped(details, context),
    );
  }
}
