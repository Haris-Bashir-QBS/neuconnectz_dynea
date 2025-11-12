import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final int? maxLines;
  final TextAlign textAlign;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 16,
    this.maxLines,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.black,
        overflow: TextOverflow.ellipsis,
        //color: color ?? (context.isDarkMode ? Colors.white : Colors.black),
      ),
      maxLines: maxLines,
    );
  }
}
