import 'package:flutter/material.dart';
import 'package:mobilki/components/text_field_container.dart';
import 'package:mobilki/constants.dart';

class PasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const PasswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
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
            suffixIcon: const Icon(
              Icons.visibility,
              color: orange,
            ),
            fillColor: Colors.grey.shade200,
            filled: true),
      ),
    );
  }
}
