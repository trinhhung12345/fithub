import 'package:flutter/material.dart';

class OrderStatusInfo {
  final String text;
  final Color color;
  final IconData icon;

  OrderStatusInfo(this.text, this.color, this.icon);
}

class OrderStatusHelper {
  static OrderStatusInfo getStatusInfo(String status) {
    switch (status) {
      case "NEW":
        return OrderStatusInfo(
          "Chờ xác nhận",
          Colors.blue,
          Icons.inventory_2_outlined,
        );
      case "CONFIRMED":
        return OrderStatusInfo(
          "Đã xác nhận",
          Colors.indigo,
          Icons.thumb_up_alt_outlined,
        );
      case "DELIVERING":
        return OrderStatusInfo(
          "Đang giao hàng",
          Colors.orange.shade800,
          Icons.local_shipping_outlined,
        );
      case "DONE":
        return OrderStatusInfo(
          "Hoàn thành",
          Colors.green,
          Icons.check_circle_outline,
        );
      case "CANCEL":
        return OrderStatusInfo("Đã hủy", Colors.red, Icons.cancel_outlined);
      default:
        return OrderStatusInfo(
          "Không xác định",
          Colors.grey,
          Icons.help_outline,
        );
    }
  }
}
