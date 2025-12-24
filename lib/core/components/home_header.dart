import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_text_styles.dart'; // Import text style

class HomeHeader extends StatelessWidget {
  final String? avatarUrl;
  final String? userName; // <-- THÊM BIẾN NÀY
  final VoidCallback? onCartTap;
  final VoidCallback? onAvatarTap;

  const HomeHeader({
    super.key,
    this.avatarUrl,
    this.userName, // <-- THÊM VÀO CONSTRUCTOR
    this.onCartTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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

        const SizedBox(width: 12), // Khoảng cách
        // 2. Lời chào + Tên (Ở giữa)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Xin chào,",
                style: AppTextStyles.body.copyWith(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                userName ??
                    "Khách hàng", // Nếu chưa có tên thì hiện "Khách hàng"
                style: AppTextStyles.h2.copyWith(
                  fontSize: 16,
                  height: 1.2, // Chỉnh độ cao dòng cho gọn
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // Tên dài quá thì ...
              ),
            ],
          ),
        ),

        // 3. Cart Button
        GestureDetector(
          onTap: onCartTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
