import 'package:flutter/material.dart';
import '../../../../configs/app_text_styles.dart';

class OrderCard extends StatelessWidget {
  final String orderCode;
  final String itemCount; // Ví dụ: "3 items"
  final String price; // Ví dụ: "6.860.000 đ" (Thêm cái này)
  final String status; // Ví dụ: "NEW" (Thêm cái này)
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Đơn hàng #$orderCode",
                        style: AppTextStyles.h2.copyWith(fontSize: 16),
                      ),
                      // Hiển thị trạng thái nhỏ bên cạnh
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: status == "NEW"
                              ? Colors.blue.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 10,
                            color: status == "NEW" ? Colors.blue : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Hiển thị số lượng và tổng tiền
                  Text(
                    "$itemCount  |  $price",
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
