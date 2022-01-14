import 'package:flutter/material.dart';
import 'package:mobilki/components/button.dart';
import 'package:mobilki/components/date_input_field.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/components/password_field.dart';
import 'package:mobilki/constants.dart';

class Body extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function() signUp;
  final Future<void> Function(BuildContext) selectDate;
  final DateTime? dateOfBirth;
  const Body(
      {Key? key,
      required this.usernameController,
      required this.emailController,
      required this.passwordController,
      required this.signUp,
      required this.selectDate,
      required this.dateOfBirth})
      : super(key: key);

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
            textInputType: TextInputType.name,
            textEditingController: usernameController,
          ),
          InputField(
            hintText: 'Email',
            onChanged: (value) {},
            textInputType: TextInputType.emailAddress,
            textEditingController: emailController,
          ),
          DateField(date: dateOfBirth, selectDate: selectDate),
          PasswordField(
            onChanged: (value) {},
            textEditingController: passwordController,
          ),
          // TODO: SUBSCRIBING TO NEWSLETTER
          SizedBox(height: size.height * 0.03),
          Button(
              height: 0.07 * size.height,
              width: 0.86 * size.width,
              text: "Register",
              onPress: signUp,
              color: darkOrange),
        ])));
  }
}
