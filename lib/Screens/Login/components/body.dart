import 'package:flutter/material.dart';
import 'package:mobilki/components/button.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/components/password_field.dart';
import 'package:mobilki/constants.dart';

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
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
            textEditingController: _emailController,
          ),
          PasswordField(
            onChanged: (value) {},
            textEditingController: _passwordController,
          ),
          SizedBox(height: size.height * 0.03),
          Button(
              height: 0.07 * size.height,
              width: 0.86 * size.width,
              text: "Log In",
              onPress: () {},
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
