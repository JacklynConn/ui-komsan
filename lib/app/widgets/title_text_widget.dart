import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({
    super.key,
    required this.label,
    this.fontSize = 20,
    this.color,
    this.maxLines,
    this.fontFamily = 'GeneralFont',
    this.overflow,
  });

  final String label;
  final double fontSize;
  final Color? color;
  final int? maxLines;
  final String? fontFamily;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
