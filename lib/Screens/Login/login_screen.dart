import 'package:flutter/material.dart';
import 'package:mobilki/screens/Home/home_screen.dart';
import 'package:mobilki/screens/Login/components/body.dart';
import 'package:mobilki/resources/auth_methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == "success") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    } else {
      // TODO: pokaz blad
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Body(
      emailController: _emailController,
      passwordController: _passwordController,
      login: loginUser,
    ));
  }
}
