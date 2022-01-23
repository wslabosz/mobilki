import 'package:flutter/material.dart';
import 'package:mobilki/screens/Search/components/body.dart';
import 'package:mobilki/components/navbar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope (onWillPop: () async {return Navbar.navbarOnBack();}, child:const Scaffold(
      body: Body(),
      bottomNavigationBar: Navbar(index:3),
    ));
  }
}
