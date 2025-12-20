import 'package:flutter/material.dart';
import '../../../configs/app_config.dart';
import '../../cart/view_model/cart_view_model.dart';
import '../../../data/services/checkout_service.dart'; // Import Service vừa tạo

class CheckoutViewModel extends ChangeNotifier {
  final CheckoutService _checkoutService =
      CheckoutService(); // Khởi tạo Service

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final double shippingFee = 30000;

  Future<bool> placeOrder(
    CartViewModel cartViewModel, {
    required String name,
    required String phone,
    required String address,
    required String note,
  }) async {
    _isLoading = true;
    notifyListeners();

    // 1. Logic Mock (Giữ lại để test UI nếu cần)
    if (AppConfig.mockCheckout) {
      await Future.delayed(const Duration(seconds: 2));
      cartViewModel.clearCart();
      _isLoading = false;
      notifyListeners();
      return true;
    }

    // 2. Logic API Thật
    // Lưu ý: Hiện tại API của bạn chỉ cần userId, chưa lưu địa chỉ/tên vào DB
    // (Sau này nếu API update cần truyền address, bạn thêm vào body ở Service nhé)
    final success = await _checkoutService.createOrder();

    if (success) {
      // Đặt hàng thành công -> Xóa giỏ hàng local để đồng bộ với server
      cartViewModel.clearCart();
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
