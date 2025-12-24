import 'package:flutter/material.dart';
import '../../../../configs/app_colors.dart';
import '../../../../configs/app_text_styles.dart';
import '../../../../data/models/order_model.dart';

class NotificationItem extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const NotificationItem({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Logic tạo nội dung thông báo dựa trên Status
    String title = "";
    String content = "";
    IconData icon = Icons.notifications;
    Color iconColor = Colors.blue;

    switch (order.status) {
      case "NEW":
        title = "Đặt hàng thành công";
        content =
            "Đơn hàng #${order.id} đã được tạo thành công. Vui lòng chờ xác nhận.";
        icon = Icons.inventory_2;
        iconColor = AppColors.primary;
        break;
      case "CONFIRMED":
        title = "Đơn hàng đã xác nhận";
        content = "Đơn hàng #${order.id} của bạn đã được cửa hàng xác nhận.";
        icon = Icons.thumb_up;
        iconColor = Colors.indigo;
        break;
      case "DELIVERING":
        title = "Đang giao hàng";
        content = "Đơn hàng #${order.id} đang trên đường giao đến bạn.";
        icon = Icons.local_shipping;
        iconColor = Colors.orange;
        break;
      case "DONE":
        title = "Giao hàng thành công";
        content =
            "Đơn hàng #${order.id} đã giao thành công. Hãy đánh giá sản phẩm nhé!";
        icon = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case "CANCEL":
        title = "Đơn hàng đã hủy";
        content = "Đơn hàng #${order.id} đã bị hủy.";
        icon = Icons.cancel;
        iconColor = Colors.red;
        break;
      default:
        title = "Cập nhật đơn hàng";
        content = "Đơn hàng #${order.id} có cập nhật mới.";
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // Thêm border nhẹ
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon tròn
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),

            // Nội dung text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Hiển thị ngày giờ (Nếu API trả về null thì hiện "Vừa xong")
                  Text(
                    _formatDate(order.createdAt),
                    style: TextStyle(color: Colors.grey[400], fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "Vừa xong";
    // Bạn có thể dùng DateFormat để format đẹp hơn
    // Ví dụ đơn giản: Cắt chuỗi lấy ngày
    return dateStr.split('T')[0];
  }
}
