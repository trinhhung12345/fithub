import 'package:flutter/material.dart';
import '../../../../configs/app_colors.dart';
import '../../../../configs/app_text_styles.dart';

class NotificationCard extends StatelessWidget {
  final String content;
  final bool isUnread;

  const NotificationCard({
    super.key,
    required this.content,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4), // Màu xám nhạt nền card
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon chuông
          Stack(
            children: [
              const Icon(Icons.notifications_none_outlined, size: 28),
              if (isUnread)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Nội dung text
          Expanded(
            child: Text(
              content,
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
                height: 1.4, // Giãn dòng cho dễ đọc
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
