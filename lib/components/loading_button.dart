import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  final Color color, textColor;
  final double width, height;
  final RoundedLoadingButtonController buttonController;
  const LoadingButton({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
    required this.onPress,
    required this.color,
    required this.buttonController,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: newRoundedLoadingButton(),
      ),
    );
  }

  Widget newRoundedLoadingButton() {
    return RoundedLoadingButton(
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600)),
        onPressed: onPress,
        color: color,
        controller: buttonController);
  }
}
