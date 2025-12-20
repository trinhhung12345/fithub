import 'package:flutter/material.dart';
import '../../../configs/app_config.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/order_model.dart';

class OrderViewModel extends ChangeNotifier {
  List<OrderModel> _allOrders = [];
  List<OrderModel> _filteredOrders = [];

  List<OrderModel> get orders => _filteredOrders;

  // Danh sách trạng thái để hiển thị trên FilterBar
  final List<String> statusList = [
    "Tất cả",
    "Đang xử lý",
    "Đã giao",
    "Đã hủy",
    "Hoàn trả",
  ];

  int _selectedStatusIndex = 0;
  int get selectedStatusIndex => _selectedStatusIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    if (AppConfig.mockOrder) {
      await Future.delayed(const Duration(milliseconds: 500));
      _allOrders = MockData.orders;
      _filterOrders(); // Lọc lần đầu
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
      // Index 0 là "Tất cả"
      _filteredOrders = List.from(_allOrders);
    } else {
      final status = statusList[_selectedStatusIndex];
      _filteredOrders = _allOrders.where((o) => o.status == status).toList();
    }
  }
}
