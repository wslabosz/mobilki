import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Profile/components/body.dart';
import 'package:mobilki/models/user.dart';


class ProfileScreen extends StatelessWidget {
  final User profile;
  const ProfileScreen({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Body(profile:profile),
        );
  }
}
