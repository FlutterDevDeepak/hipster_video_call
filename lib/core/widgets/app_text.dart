import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final Color? color;
  final double fontSize;
  final TextAlign alignment;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDecoration? decoration;
  const AppText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w500,
    this.color,
    this.fontSize = 15,
    this.alignment = TextAlign.left,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: alignment,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.varelaRound(
        textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
         decoration: decoration
        ),
      ),
    );
  }
}
