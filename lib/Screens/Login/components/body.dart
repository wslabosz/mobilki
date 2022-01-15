import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobilki/components/button.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/components/password_field.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/screens/Login/reset_screen.dart';

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
          
          TextButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ResetScreen())),
              child: const Text('Forgot your password?',
                  style: TextStyle(
                      color: lightOrange,
                      fontSize: 18,
                      fontWeight: FontWeight.w600))),
          //TODO: link do rejestracji
          Padding(
              padding: EdgeInsets.only(top: size.height * 0.03),
              child: FloatingActionButton.extended(
                onPressed: () {
                  GoogleSignIn().signIn();
                },
                icon: Image.asset(
                  'assets/images/google_logo.png',
                  height: size.height * 0.12,
                  width: size.width * 0.12,
                ),
                label: const Text('Sign in with Google'),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ))
        ])));
  }
}
