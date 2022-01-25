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
  String? _error;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  void resetPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();
    String response =
        await AuthMethods().resetPassword(email: _emailController.text);
    if (response == 'success') {
      Navigator.of(context).pop();
    } else if (response == 'please enter the email') {
      setState(() {
        _error = response;
      });
    } else {
      showDialog<void>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text(
                    "If provided email exists, check your inbox"),
                actions: [
                  TextButton(
                      child: const Text("Confirm",
                          style: TextStyle(color: Colors.red)),
                      onPressed: () => {
                            Navigator.of(context)
                              ..pop()
                              ..pop()
                          })
                ],
              ));
    }
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
            onChanged: (value) {},
            textInputType: TextInputType.emailAddress,
            textEditingController: _emailController,
            errorText: _error,
          ),
          SizedBox(height: size.height * 0.02),
          Button(
              height: 0.07 * size.height,
              width: 0.86 * size.width,
              text: "Send link on email",
              onPress: resetPassword,
              color: darkOrange)
        ]))));
  }
}
