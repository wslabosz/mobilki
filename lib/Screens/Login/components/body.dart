import 'package:flutter/material.dart';
import 'package:mobilki/components/button.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/components/password_field.dart';
import 'package:mobilki/constants.dart';

class Body extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function() login;
  const Body(
      {Key? key,
      required this.emailController,
      required this.passwordController,
      required this.login})
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
            "Log In",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: size.height * 0.03),
          InputField(
            hintText: 'Email',
            onChanged: (value) {},
            textInputType: TextInputType.emailAddress,
            textEditingController: emailController,
          ),
          PasswordField(
            onChanged: (value) {},
            textEditingController: passwordController,
          ),
          SizedBox(height: size.height * 0.03),
          Button(
              height: 0.07 * size.height,
              width: 0.86 * size.width,
              text: "Log In",
              onPress: login,
              color: darkOrange),
          SizedBox(height: size.height * 0.02),
          const Text('Forgot your password?',
              style: TextStyle(
                  color: lightOrange,
                  fontSize: 18,
                  fontWeight: FontWeight.w600))
        ])));
  }
}
