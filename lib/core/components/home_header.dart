import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';

class HomeHeader extends StatelessWidget {
  final String? avatarUrl;
  final VoidCallback? onCartTap;
  final VoidCallback? onAvatarTap;

  const HomeHeader({
    super.key,
    this.avatarUrl,
    this.onCartTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1. Avatar
        GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: (avatarUrl != null && avatarUrl!.isNotEmpty)
                ? NetworkImage(avatarUrl!)
                : null,
            child: (avatarUrl == null || avatarUrl!.isEmpty)
                ? const Icon(Icons.person, color: Colors.white)
                : null,
          ),
        ),

        // 2. Cart Button
        GestureDetector(
          onTap: onCartTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.primary, // Màu cam chủ đạo
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
