import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobilki/screens/Login/components/body.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  String? _error;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _loginUser() async {
    setState(() {
      _buttonController.start();
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    //TODO: RESPONSE NA STRINGU
    if (res == "success") {
      setState(() {
        _buttonController.success();
      });
      Navigator.of(context).pushNamedAndRemoveUntil('home',
          (route) => false);

    } else {
      setState(() {
        _error = "invalid email or password";
        _buttonController.error();
        Timer(const Duration(seconds: 2), () {
          _buttonController.stop();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Body(
      emailController: _emailController,
      passwordController: _passwordController,
      login: _loginUser,
      buttonController: _buttonController,
      validationError: _error,
    ));
  }
}
