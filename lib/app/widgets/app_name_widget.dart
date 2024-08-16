import 'package:flutter/material.dart';

class AppNameTextWidget extends StatelessWidget {
  const AppNameTextWidget({
    super.key,
    this.fontSize = 28,
  });

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Komsan',
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'LogoFont',
        color: Colors.blueAccent,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
