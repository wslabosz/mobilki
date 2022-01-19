import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:mobilki/constants.dart';

class SegControl extends StatelessWidget {
  final void Function(bool) notifyParent;
  final String nameLeft;
  final String nameRight;
  final bool rightActive;

  const SegControl(
      {Key? key,
      required this.nameLeft,
      required this.nameRight,
      required this.notifyParent,
      this.rightActive = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CustomSlidingSegmentedControl(
        children: {
          false: Text(nameLeft,
              textAlign: TextAlign.center,
              style: rightActive == true
                  ? const TextStyle(fontWeight: FontWeight.w900)
                  : const TextStyle(
                      fontWeight: FontWeight.w900, color: darkOrange)),
          true: Text(nameRight,
              textAlign: TextAlign.center,
              style: rightActive == false
                  ? const TextStyle(fontWeight: FontWeight.w900)
                  : const TextStyle(
                      fontWeight: FontWeight.w900, color: darkOrange))
        },
        fromMax: true,
        initialValue: rightActive,
        fixedWidth: size.width * 0.45,
        radius: 80,
        onValueChanged: notifyParent);
  }
}
