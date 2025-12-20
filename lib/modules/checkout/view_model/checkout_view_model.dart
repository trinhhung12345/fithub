import 'package:flutter/material.dart';
import '../../../configs/app_config.dart';
import '../../cart/view_model/cart_view_model.dart'; // Cần access Cart để xóa

class CheckoutViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Phí ship giả định
  final double shippingFee = 30000;

  // Giả lập gọi API đặt hàng
  Future<bool> placeOrder(
    CartViewModel cartViewModel, {
    required String name,
    required String phone,
    required String address,
    required String note,
  }) async {
    _isLoading = true;
    notifyListeners();

    bool success = false;

    if (AppConfig.mockCheckout) {
      await Future.delayed(const Duration(seconds: 2)); // Giả vờ xử lý
      success = true; // Luôn thành công
    } else {
      // Gọi API thật: POST /orders
      // Body: { items: cartItems, address: ..., paymentMethod: "COD" }
    }

    if (success) {
      // Đặt hàng thành công thì phải xóa sạch giỏ hàng
      cartViewModel.clearCart();
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
