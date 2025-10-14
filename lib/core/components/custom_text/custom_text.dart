import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FontFamily {
  static const String lexend = 'Lexend';
  static const String poppins = 'Poppins';
}

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.black,
    this.fontFamily,
    this.height,
    this.letterSpacing,
    this.overflow,
    this.decoration,
    this.textAlign,
    this.maxLines,

    ///this.decoration = TextDecoration.none,
  });

  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final String? fontFamily;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final int? maxLines;
  final TextAlign? textAlign;
  final double? height;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        decorationColor: Colors.black,
        fontFamily: fontFamily ?? FontFamily.poppins,
        height: height,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
