import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Social/components/body.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/components/navbar.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/resources/default_snackbar.dart';
import 'package:mobilki/resources/firestore_methods.dart';

import '../../constants.dart';

class SocialScreen extends StatelessWidget {
  const SocialScreen({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return Navbar.navbarOnBack();
        },
        child: Scaffold(
          body: const Body(),
          bottomNavigationBar: const Navbar(index: 4),
          floatingActionButton: FloatingActionButton(
            onPressed: () => teamCreateDialog(context),
            backgroundColor: orange,
            child: const Icon(Icons.add),
          ),
        ));
  }
}
