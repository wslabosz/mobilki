import 'package:flutter/material.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/components/navbar.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/resources/default_snackbar.dart';
import 'package:mobilki/resources/firestore_methods.dart';
import 'package:mobilki/screens/Social/components/body.dart';

import '../../constants.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  bool _rightSegment = false;

  void _switchSegment(bool right) {
    setState(() {
      _rightSegment = right;
    });
  }

  void teamCreateDialog(BuildContext context) {
    TextEditingController teamController = TextEditingController();
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
            title: const Text("Add a team with chosen name"),
            actions: [
              TextButton(
                  child:
                      const Text("Cancel", style: TextStyle(color: Colors.red)),
                  onPressed: () => {
                        Navigator.of(context, rootNavigator: true).pop('dialog')
                      }),
              TextButton(
                child: const Text('Add a team',
                    style: TextStyle(color: darkOrange)),
                onPressed: () {
                  FireStoreMethods.addTeam(teamController.text).then((result) {
                    Snackbars.defaultSnackbar(context, result[0],
                        positive: result[1]);
                    if (result[1]) {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    }
                  });
                },
              )
            ],
            content: InputField(
              hintText: 'Team name',
              onChanged: (value) {},
              textInputType: TextInputType.name,
              textEditingController: teamController,
            )));
  }

  FloatingActionButton? buildAddTeamButton(bool isRightSegment) {
    if (isRightSegment) {
      return FloatingActionButton(
        onPressed: () => teamCreateDialog(context),
        backgroundColor: orange,
        child: const Icon(Icons.add),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return Navbar.navbarOnBack();
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Social'),
            backgroundColor: Colors.orange,
          ),
          body: Body(segment: _rightSegment, switchSegment: _switchSegment),
          floatingActionButton: buildAddTeamButton(_rightSegment),
          bottomNavigationBar: const Navbar(index: 2),
        ));
  }
}
