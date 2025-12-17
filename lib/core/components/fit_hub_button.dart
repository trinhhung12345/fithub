import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_text_styles.dart';

class FitHubButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const FitHubButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Bo tròn nhiều như design
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(text, style: AppTextStyles.button),
      ),
    );
  }
}
