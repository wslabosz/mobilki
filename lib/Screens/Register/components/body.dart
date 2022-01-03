import 'package:flutter/material.dart';
import 'package:mobilki/components/button.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/components/password_field.dart';
import 'package:mobilki/constants.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          const Text(
            "Register",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          InputField(
            hintText: "Name",
            onChanged: (value) {},
          ),
          InputField(
            hintText: 'Email',
            onChanged: (value) {},
          ),
          PasswordField(onChanged: (value) {}),
          // TODO: SUBSCRIBING TO NEWSLETTER
          SizedBox(height: size.height * 0.03),
          Button(
              height: 0.07 * size.height,
              width: 0.86 * size.width,
              text: "Register",
              onPress: () {},
              color: darkOrange),
        ])));
  }
}
