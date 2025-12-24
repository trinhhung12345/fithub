import 'package:flutter/material.dart';
import '../../../configs/app_config.dart';
import '../../../data/models/order_model.dart';
import '../../../data/services/order_service.dart'; // Import service

class OrderViewModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<OrderModel> _allOrders = [];
  List<OrderModel> _filteredOrders = [];
  List<OrderModel> get orders => _filteredOrders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Tabs hiển thị trên UI
  final List<String> statusList = [
    "Tất cả",
    "Chờ xác nhận",
    "Đang giao",
    "Hoàn thành",
    "Đã hủy",
  ];
  int _selectedStatusIndex = 0;
  int get selectedStatusIndex => _selectedStatusIndex;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    if (AppConfig.mockOrder) {
      // Logic mock cũ...
    } else {
      // Gọi API thật
      _allOrders = await _orderService.getMyOrders();

      // Sắp xếp đơn mới nhất lên đầu (Dựa vào ID giảm dần vì ID thường tự tăng)
      _allOrders.sort((a, b) => b.id.compareTo(a.id));

      _filterOrders();
    }

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(int index) {
    _selectedStatusIndex = index;
    _filterOrders();
    notifyListeners();
  }

  void _filterOrders() {
    if (_selectedStatusIndex == 0) {
      _filteredOrders = List.from(_allOrders);
    } else {
      final uiStatus = statusList[_selectedStatusIndex];

      _filteredOrders = _allOrders.where((order) {
        // Map từ UI Tab sang Backend Status
        if (uiStatus == "Chờ xác nhận") {
          return order.status == "NEW" ||
              order.status == "CONFIRMED"; // Gom cả 2 vào tab đầu
        }
        if (uiStatus == "Đang giao") return order.status == "DELIVERING";
        if (uiStatus == "Hoàn thành") return order.status == "DONE";
        if (uiStatus == "Đã hủy") return order.status == "CANCEL";
        return false;
      }).toList();
    }
  }

  Future<bool> cancelOrder(int orderId) async {
    _isLoading = true;
    notifyListeners();

    final success = await _orderService.cancelOrder(orderId);

    if (success) {
      // --- CẬP NHẬT UI LOCAL NGAY LẬP TỨC ---
      // Tìm đơn hàng trong list và đổi status thành CANCEL
      final index = _allOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        // Vì OrderModel là final (immutable), ta phải tạo object mới copy từ cũ
        final oldOrder = _allOrders[index];
        final newOrder = OrderModel(
          id: oldOrder.id,
          status: "CANCEL", // Cập nhật status mới
          totalAmount: oldOrder.totalAmount,
          createdAt: oldOrder.createdAt,
          items: oldOrder.items,
        );

        _allOrders[index] = newOrder;

        // Cập nhật lại list filter hiện tại
        _filterOrders();
      }
    }

    _isLoading = false;
    notifyListeners();

    return success;
  }
}
