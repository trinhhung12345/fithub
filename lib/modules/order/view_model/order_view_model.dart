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
  final List<String> statusList = ["Tất cả", "Đang xử lý", "Đã giao", "Đã hủy"];
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

      // LOGIC MAP STATUS: Backend ("NEW") <-> UI ("Đang xử lý")
      _filteredOrders = _allOrders.where((order) {
        if (uiStatus == "Đang xử lý") return order.status == "NEW";
        if (uiStatus == "Đã giao")
          return order.status == "DELIVERED"; // Dự đoán
        if (uiStatus == "Đã hủy") return order.status == "CANCELLED"; // Dự đoán
        return false;
      }).toList();
    }
  }
}
