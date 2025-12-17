import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Font cho tiêu đề lớn (Bricolage Grotesque)
  static TextStyle h1 = GoogleFonts.bricolageGrotesque(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static TextStyle h2 = GoogleFonts.bricolageGrotesque(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  // Font cho nội dung (Inter)
  static TextStyle body = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle link = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
  );
}
