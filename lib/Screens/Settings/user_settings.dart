import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final String name;
  final String urlImage;

  const SettingsPage({
    Key? key,
    required this.name,
    required this.urlImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(name),
          centerTitle: true,
        ),
        body: Image.network(
          urlImage,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
}
