import 'package:flutter/material.dart';
import '../../../data/models/order_model.dart';
import '../../../data/services/order_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  // Dùng luôn OrderModel để hiển thị
  List<OrderModel> _notifications = [];
  List<OrderModel> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Gọi API lấy danh sách đơn hàng
      final orders = await _orderService.getMyOrders();

      // 2. Sắp xếp: Đơn mới nhất (ID lớn nhất) lên đầu
      orders.sort((a, b) => b.id.compareTo(a.id));

      _notifications = orders;
    } catch (e) {
      print("Lỗi load thông báo: $e");
      _notifications = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
