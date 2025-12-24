import 'package:flutter/material.dart';
import '../../../../configs/app_text_styles.dart';
import '../../../../core/utils/order_status_helper.dart'; // Import Helper

class OrderCard extends StatelessWidget {
  final String orderCode;
  final String itemCount;
  final String price;
  final String status; // Giá trị: NEW, CONFIRMED...
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.orderCode,
    required this.itemCount,
    required this.price,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin màu/icon từ helper
    final statusInfo = OrderStatusHelper.getStatusInfo(status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // Nền trắng cho sạch
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200), // Viền mỏng
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Mã đơn hàng
                Text(
                  "Đơn hàng #$orderCode",
                  style: AppTextStyles.h2.copyWith(fontSize: 16),
                ),

                // Badge Trạng thái
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusInfo.color.withOpacity(0.1), // Nền nhạt
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(statusInfo.icon, size: 14, color: statusInfo.color),
                      const SizedBox(width: 4),
                      Text(
                        statusInfo.text,
                        style: TextStyle(
                          fontSize: 12,
                          color: statusInfo.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24), // Đường gạch ngang phân cách
            Row(
              children: [
                // Info bên dưới
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemCount,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
