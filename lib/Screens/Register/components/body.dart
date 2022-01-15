import 'package:flutter/material.dart';
import 'package:mobilki/components/date_input_field.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/components/loading_button.dart';
import 'package:mobilki/components/password_field.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/screens/Login/login_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Body extends StatelessWidget {
  final TextEditingController firstnameController;
  final TextEditingController lastnameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final RoundedLoadingButtonController buttonController;
  final void Function() signUp;
  final Future<void> Function(BuildContext) selectDate;
  final DateTime? dateOfBirth;
  final Map<String, String>? validationErrors;
  const Body(
      {Key? key,
      required this.firstnameController,
      required this.lastnameController,
      required this.emailController,
      required this.passwordController,
      required this.signUp,
      required this.selectDate,
      required this.dateOfBirth,
      required this.buttonController,
      required this.validationErrors})
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
            "Sign in",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          InputField(
            hintText: "First name",
            onChanged: (value) {},
            textInputType: TextInputType.name,
            textEditingController: firstnameController,
          ),
          InputField(
            hintText: "Last name",
            onChanged: (value) {},
            textInputType: TextInputType.name,
            textEditingController: lastnameController,
          ),
          InputField(
            hintText: 'Email',
            onChanged: (value) {},
            errorText: validationErrors?['email'],
            textInputType: TextInputType.emailAddress,
            textEditingController: emailController,
          ),
          DateField(date: dateOfBirth, selectDate: selectDate),
          PasswordField(
            onChanged: (value) {},
            errorText: validationErrors?['password'],
            textEditingController: passwordController,
          ),
          // TODO: SUBSCRIBING TO NEWSLETTER
          SizedBox(height: size.height * 0.03),
          LoadingButton(
              buttonController: buttonController,
              color: darkOrange,
              height: 0.07 * size.height,
              width: 0.86 * size.width,
              onPress: signUp,
              text: 'Sign in'),
          TextButton(
              child: const Text("Already have an account? Log in!",
                  style: TextStyle(
                      color: orange,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginScreen()))),
        ])));
  }
}
