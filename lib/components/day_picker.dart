import 'package:flutter/material.dart';
import 'package:mobilki/components/text_field_container.dart';
import 'package:mobilki/constants.dart';

class DateDayPicker extends StatelessWidget {
  final DateTime? date;
  final Future<void> Function(BuildContext) selectDate;
  const DateDayPicker({Key? key, required this.date, required this.selectDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        width: 0.45,
        child: TextButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(12.0))),
          onPressed: () => selectDate(context),
          child: Text(
            date == null ? "Date" : "${date!.toLocal()}".split(' ')[0],
            style: const TextStyle(
                color: orange, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ));
  }
}
