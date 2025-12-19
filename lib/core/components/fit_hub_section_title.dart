import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_text_styles.dart';

class FitHubSectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const FitHubSectionTitle({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h2.copyWith(fontSize: 18)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              "Xem tất cả",
              style: AppTextStyles.body.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
