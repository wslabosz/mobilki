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
  // TODO: do zaimplementowania cos z ladowaniem
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        //TODO: dodac 
        dateOfBirth: "00");
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
        signUp: signUpUser,
      ),
      bottomNavigationBar: const Navbar(index: 1),
    );
  }
}
