import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Login/login_screen.dart';
import 'package:mobilki/Screens/Register/register_screen.dart';
import 'package:mobilki/constants.dart';

// do wywalenia jak zostaną zrobione screeny
class _UnimplementedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class Navbar extends StatelessWidget {
  final int index;
  const Navbar({Key? key, 
  required this.index}) : super(key: key);

  static final _pages = [
    const LoginScreen(), // home
    const RegisterScreen(), // event
    _UnimplementedScreen(), // add
    _UnimplementedScreen(), // people
    _UnimplementedScreen(), // search

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => _pages[index]));
              });
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> itemList = [];
    for(var i = 0 ; i < 5 ; i ++) {
      itemList.add(BottomNavigationBarItem(icon:_icons[i],label:_names[i]));
    }
    return BottomNavigationBar(
      items: itemList,
      currentIndex: index,
      selectedItemColor: orange,
      unselectedItemColor: black,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      onTap: (details) => _onItemTapped(details,context),
    );
  }
}
