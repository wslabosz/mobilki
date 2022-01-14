import 'package:flutter/material.dart';
import 'package:mobilki/components/text_field_container.dart';
import 'package:mobilki/constants.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController textEditingController;
  final ValueChanged<String> onChanged;
  const PasswordField({
    Key? key,
    required this.textEditingController,
    required this.onChanged,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _showPassword = true;
  Icon _iconToShow = Icon(Icons.visibility_off);

  void setPasswordVisible() {
    setState(() {
      _showPassword = !_showPassword;
      if (_showPassword) {
        _iconToShow = Icon(Icons.visibility_off);
      } else {
        _iconToShow = Icon(Icons.visibility);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: widget.textEditingController,
        keyboardType: TextInputType.text,
        obscureText: _showPassword,
        onChanged: widget.onChanged,
        cursorColor: orange,
        decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.0)),
            hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
                fontSize: 18),
            suffixIcon: IconButton(
              icon: _iconToShow,
              onPressed: () => {setPasswordVisible()},
              color: orange,
              splashRadius: 1.0,
            ),
            fillColor: Colors.grey.shade200,
            filled: true),
      ),
    );
  }
}
