import 'package:flutter/material.dart';

class SubtitleWidget extends StatelessWidget {

  final String label;
  final double fontSize;
  final FontStyle fontStyle;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final Color? color;
  final TextOverflow? overflow;
  final TextDecoration textDecoration;
  final int? maxLines;
  final TextAlign? textAlign;

  const SubtitleWidget({
    super.key,
    required this.label,
    this.fontSize = 18,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textDecoration = TextDecoration.none,
    this.fontFamily = 'GeneralFont',
    this.overflow,
    this.maxLines,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
        decoration: textDecoration,
        overflow: overflow,
      ),
      maxLines: maxLines,
      textAlign: textAlign ,
    );
  }
}
