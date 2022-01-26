import 'package:flutter/material.dart';
import 'package:mobilki/screens/Search/components/body.dart';
import 'package:mobilki/components/navbar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return Navbar.navbarOnBack();
        },
        child:  Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Search'),
            backgroundColor: Colors.orange,
          ),
          body: const Body(),
          bottomNavigationBar: const Navbar(index: 1),
        ));
  }
}
