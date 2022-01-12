import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Home/home_screen.dart';
import 'package:mobilki/Screens/Register/register_screen.dart';
import 'package:mobilki/Screens/Search/search_screen.dart';
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
  const Navbar({Key? key, required this.index}) : super(key: key);

  static final _pages = [
    const HomeScreen(), // home
    const RegisterScreen(), // event
    _UnimplementedScreen(), // add
    _UnimplementedScreen(), // people
    const SearchScreen(), // search
  ];

  static final _route_names = [
    "home",
    "register",
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
      Navigator.of(context).pushNamedAndRemoveUntil("/" + _route_names[index],
          ModalRoute.withName("/" + _route_names[index]));
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
