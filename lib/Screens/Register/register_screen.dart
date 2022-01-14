import 'package:flutter/material.dart';
import 'package:mobilki/screens/Home/home_screen.dart';
import 'package:mobilki/screens/Register/components/body.dart';
import 'package:mobilki/components/navbar.dart';
import 'package:mobilki/resources/auth_methods.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  DateTime? _dateOfBirth;
  // TODO: do zaimplementowania cos z ladowaniem
  bool _isLoading = false;

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

  void _signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        dateOfBirth: _dateOfBirth.toString());
    // TODO: TO TRZEBA ZMIENIC
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    } else {
      setState(() {
        _isLoading = false;
      });
      // TODO: pokaz blad
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
      ),
      bottomNavigationBar: const Navbar(index: 1),
    );
  }
}
