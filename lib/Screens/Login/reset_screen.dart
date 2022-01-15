import 'package:flutter/material.dart';
import 'package:mobilki/components/button.dart';
import 'package:mobilki/components/input_field.dart';
import 'package:mobilki/constants.dart';
import 'package:mobilki/resources/auth_methods.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void resetPassword() async {
    await AuthMethods().resetPassword(email: _emailController.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
          const Text(
            "Reset password",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: size.height * 0.03),
          InputField(
            hintText: 'Email',
            //TODO: tutaj
            errorText: "",
            onChanged: (value) {},
            textInputType: TextInputType.emailAddress,
            textEditingController: _emailController,
          ),
          Button(
              height: 0.07 * size.height,
              width: 0.86 * size.width,
              text: "Send reset link",
              onPress: resetPassword,
              color: darkOrange)
        ]))));
  }
}
