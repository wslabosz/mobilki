import 'package:flutter/material.dart';
import 'components/add.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
          body: NewEventForm(),
        );
  }
}
