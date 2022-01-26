import 'package:flutter/material.dart';
import 'package:mobilki/components/text_field_container.dart';
import 'package:mobilki/constants.dart';

class DateField extends StatelessWidget {
  final DateTime? date;
  final Future<void> Function(BuildContext) selectDate;
  final String? errorText;
  const DateField(
      {Key? key, required this.date, required this.selectDate, this.errorText})
      : super(key: key);

  String showDateOfBirth(DateTime? date) {
    if (errorText != null) {
      return errorText!;
    } else if (date == null) {
      return "Date of birth";
    } else {
      return "${date.toLocal()}".split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        width: 0.75,
        child: TextButton(
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(12.0))),
      onPressed: () => selectDate(context),
      child: Text(
        showDateOfBirth(date),
        style: const TextStyle(
            color: orange, fontSize: 18, fontWeight: FontWeight.w700),
      ),
    ));
  }
}
