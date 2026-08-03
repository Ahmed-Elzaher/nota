import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontStyles {
  static TextStyle get h1 => GoogleFonts.tajawal(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get h2 => GoogleFonts.tajawal(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get h3 => GoogleFonts.tajawal(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get h4 => GoogleFonts.tajawal(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get body => GoogleFonts.tajawal(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get caption => GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w300,
      );
}
