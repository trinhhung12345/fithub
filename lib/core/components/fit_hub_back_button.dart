import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';

class FitHubBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const FitHubBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onPressed ?? () => Navigator.pop(context),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.inputBackground, // Màu nền xám nhạt
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
