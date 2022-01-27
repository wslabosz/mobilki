import 'package:flutter/material.dart';
import 'package:mobilki/components/text_field_container.dart';
import 'package:mobilki/constants.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final String? errorText;
  final TextInputAction? inputAction;
  final void Function()? onSubmitFunction;
  const InputField(
      {Key? key,
      required this.hintText,
      required this.onChanged,
      required this.textInputType,
      required this.textEditingController,
      this.onSubmitFunction,
      this.errorText,
      this.inputAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      error: errorText,
      width: 0.75,
      child: TextField(
        controller: textEditingController,
        keyboardType: textInputType,
        onChanged: onChanged,
        cursorColor: orange,
        textInputAction: inputAction,
        onEditingComplete: onSubmitFunction,
        decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            errorStyle: const TextStyle(fontSize: 13),
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
