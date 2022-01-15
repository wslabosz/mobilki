import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobilki/screens/Home/home_screen.dart';
import 'package:mobilki/screens/Register/components/body.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  DateTime? _dateOfBirth;
  Map<String, String>? _errors;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1920),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _validateForm() async {
    Map<String, String>? listOfErrors;
    if (!_emailController.text.contains('@')) {
      listOfErrors?['email'] = 'given email is invalid';
    }
    if (_passwordController.text.length < 6) {
      listOfErrors?['password'] = 'password must be longer than 6 characters';
    }
    setState(() {
      _errors = listOfErrors;
    });
  }

  void _signUpUser() async {
    setState(() {
      _buttonController.start();
    });
    await _validateForm();
    if (_errors == null) {
      String res = await AuthMethods().signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
          username: _usernameController.text,
          dateOfBirth: (_dateOfBirth?.toString() != null)
              ? _dateOfBirth.toString()
              : "");
      // TODO: RESPONSE NA STRINGU DO ZMIANY
      if (res == "success") {
        setState(() {
          _buttonController.success();
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false);
      }
      // TODO: blad firebase'a
      
    } else {
      setState(() {
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
      usernameController: _usernameController,
      emailController: _emailController,
      passwordController: _passwordController,
      signUp: _signUpUser,
      selectDate: _selectDate,
      dateOfBirth: _dateOfBirth,
      buttonController: _buttonController,
      validationErrors: _errors,
    ));
  }
}
