import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Color primary = const Color(0xFF1b1d1f);
TextStyle appStyle(double size, Color color, FontWeight fw) {
  return GoogleFonts.roboto(fontSize: size.sp, color: color, fontWeight: fw);
}
