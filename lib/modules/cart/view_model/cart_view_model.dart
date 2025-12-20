import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../configs/app_config.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/product_model.dart';

class CartViewModel extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Tính tổng tiền toàn bộ giỏ hàng
  double get totalAmount {
    double total = 0;
    for (var item in _cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  // Format tiền tệ cho UI
  String get formattedTotalAmount {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatCurrency.format(totalAmount);
  }

  // Load giỏ hàng
  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    if (AppConfig.mockCart) {
      await Future.delayed(const Duration(milliseconds: 800)); // Giả vờ load
      // Clone list để thao tác không ảnh hưởng gốc MockData static
      _cartItems = List.from(MockData.cartItems);
    } else {
      // Gọi API thật
    }

    _isLoading = false;
    notifyListeners();
  }

  // Tăng số lượng
  void increaseQuantity(int cartId) {
    final index = _cartItems.indexWhere((item) => item.id == cartId);
    if (index != -1) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  // Giảm số lượng
  void decreaseQuantity(int cartId) {
    final index = _cartItems.indexWhere((item) => item.id == cartId);
    if (index != -1 && _cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      notifyListeners();
    }
  }

  // Xóa sản phẩm
  void removeItem(int cartId) {
    _cartItems.removeWhere((item) => item.id == cartId);
    notifyListeners();
  }

  void addToCart(Product product, int quantity) {
    // 1. Kiểm tra xem sản phẩm này đã có trong giỏ chưa
    final index = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index != -1) {
      // 2a. Nếu có rồi -> Cộng thêm số lượng
      _cartItems[index].quantity += quantity;
    } else {
      // 2b. Nếu chưa có -> Tạo CartItem mới
      // (Mock ID giỏ hàng bằng thời gian hiện tại để không trùng)
      final newCartItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch,
        product: product,
        quantity: quantity,
      );
      _cartItems.add(newCartItem);
    }

    // 3. Cập nhật UI
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
