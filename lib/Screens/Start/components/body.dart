import 'package:flutter/material.dart';
import 'package:mobilki/Screens/Login/login_screen.dart';
import 'package:mobilki/Screens/Register/register_screen.dart';
import 'package:mobilki/components/button.dart';
import 'package:mobilki/constants.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Button(
            height: 0.07 * size.height,
            width: 0.44 * size.width,
            color: orange,
            text: 'Register',
            onPress: () {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()));
              });
            }),
        Button(
            height: 0.07 * size.height,
            width: 0.44 * size.width,
            color: darkOrange,
            text: 'Log in',
            onPress: () {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              });
            })
      ],
    );
    return Column(
      children: <Widget>[
        Container(
          child: Image.asset(
            'assets/images/logo.png',
            semanticLabel: 'logo',
            width: size.width * 0.5,
            height: size.height * 0.5,
          ),
          height: size.height * 0.88,
          alignment: Alignment.center,
        ),
        buttonSection,
      ],
    );
  }
}
