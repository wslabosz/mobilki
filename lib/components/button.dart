import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  final Color color, textColor;
  final double width, height;
  const Button({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
    required this.onPress,
    required this.color,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: newElevatedButton(),
      ),
    );
  }

  Widget newElevatedButton() {
    return ElevatedButton(
      child: Text(text),
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
          primary: color,
          textStyle: TextStyle(
              color: textColor, fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }
}
