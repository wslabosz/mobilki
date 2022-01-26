import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Team/components/body.dart';
import 'package:mobilki/models/team.dart';


class TeamScreen extends StatelessWidget {
  final Team team;
  const TeamScreen({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Body(team:team),
        );
  }
}
