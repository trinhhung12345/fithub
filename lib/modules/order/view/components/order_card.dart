import 'package:flutter/material.dart';
import '../../../../configs/app_text_styles.dart';

class OrderCard extends StatelessWidget {
  final String orderCode;
  final String itemCount;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.orderCode,
    required this.itemCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9), // Màu xám nhạt nền card
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icon tờ hóa đơn
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_outlined,
                size: 20,
                color: Colors.black,
              ),
            ),

            const SizedBox(width: 16),

            // Thông tin text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order $orderCode",
                    style: AppTextStyles.h2.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$itemCount items",
                    style: AppTextStyles.body.copyWith(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Mũi tên
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
