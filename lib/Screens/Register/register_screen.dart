import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobilki/screens/Register/components/body.dart';
import 'package:mobilki/resources/auth_methods.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  DateTime? _dateOfBirth;
  Map<String, String>? _errors;

  @override
  void dispose() {
    super.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.orange, // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.red, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1920),
        lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        _errors?.clear();
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _validateForm() async {
    Map<String, String> listOfErrors = <String, String>{};
    if (!_emailController.text.contains('@')) {
      listOfErrors['email'] = 'Please provide valid email';
    }
    if (_passwordController.text.length < 6) {
      listOfErrors['password'] = 'Password must be longer than 6 characters';
    }
    if (_firstnameController.text.isEmpty) {
      listOfErrors['firstname'] = 'Please provide your firstname';
    }
    if (_lastnameController.text.isEmpty) {
      listOfErrors['lastname'] = 'Please provide your lastname';
    }
    if (_dateOfBirth == null) {
      listOfErrors['dateOfBirth'] = 'Click to provide your birthday';
    }
    setState(() {
      _errors = listOfErrors;
    });
  }

  Future<void> _checkServerErrors(String response) async {
    Map<String, String> listOfErrors = <String, String>{};
    if (response.contains('invalid-email')) {
      listOfErrors['email'] = 'Please provide valid email';
    }
    if (response.contains('email-already-in-use')) {
      listOfErrors['email'] = 'The email address is already in use';
    }
    if (response.contains('password')) {
      listOfErrors['password'] = response;
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
    if (_errors == null || _errors!.isEmpty) {
      String res = await AuthMethods().signUpUser(
          email: _emailController.text,
          password: _passwordController.text,
          name: (_firstnameController.text.trim() +
                  ' ' +
                  _lastnameController.text.trim())
              .toLowerCase(),
          dateOfBirth: (_dateOfBirth?.toString() != null)
              ? _dateOfBirth.toString()
              : "");
      if (res == "success") {
        setState(() {
          _buttonController.success();
        });
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {
        await _checkServerErrors(res);
        setState(() {
          _buttonController.error();
          Timer(const Duration(seconds: 2), () {
            _buttonController.stop();
          });
        });
      }
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
      firstnameController: _firstnameController,
      lastnameController: _lastnameController,
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
