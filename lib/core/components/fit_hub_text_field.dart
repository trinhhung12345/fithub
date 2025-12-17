import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_text_styles.dart';

class FitHubTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText; // Trạng thái ẩn/hiện text
  final Widget? suffixIcon; // Icon đuôi (ví dụ: con mắt)
  final TextInputType? keyboardType;

  const FitHubTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false, // Mặc định là hiện text (false)
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.body.copyWith(color: AppColors.hintText),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: suffixIcon, // Hiển thị icon nếu có
        ),
      ),
    );
  }
}
