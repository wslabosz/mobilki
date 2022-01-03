import 'package:flutter/material.dart';
import 'package:mobilki/components/text_field_container.dart';
import 'package:mobilki/constants.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const InputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: orange,
        decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.0)),
            hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
                fontSize: 18),
            fillColor: Colors.grey.shade200,
            filled: true),
      ),
    );
  }
}
