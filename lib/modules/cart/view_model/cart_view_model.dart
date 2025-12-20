import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../configs/app_config.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/cart_service.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _cartService = CartService();

  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  double _serverTotalPrice = 0; // Tổng tiền do Server tính trả về

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Tổng tiền: Ưu tiên lấy từ Server trả về, nếu không thì tự tính
  double get totalAmount {
    if (!AppConfig.mockCart && _serverTotalPrice > 0) {
      return _serverTotalPrice;
    }
    // Logic tự tính (cho Mock hoặc fallback)
    double total = 0;
    for (var item in _cartItems) {
      total += item.totalPrice; // item.totalPrice giờ cũng lấy từ API
    }
    return total;
  }

  String get formattedTotalAmount {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatCurrency.format(totalAmount);
  }

  // --- HÀM ADD TO CART MỚI ---
  Future<bool> addToCart(Product product, int quantity) async {
    _isLoading = true;
    notifyListeners();

    // 1. Nếu đang Mock
    if (AppConfig.mockCart) {
      // ... giữ nguyên logic mock cũ ...
      _isLoading = false;
      notifyListeners();
      return true;
    }

    // 2. Gọi API thật
    final response = await _cartService.addToCart(product.id, quantity);

    if (response != null) {
      // CẬP NHẬT DỮ LIỆU TỪ SERVER TRẢ VỀ
      _cartItems = response.items;
      _serverTotalPrice = response.totalPrice;

      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      // Thất bại
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // SỬA LẠI HÀM NÀY
  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    // 1. Logic Mock (giữ lại để test)
    if (AppConfig.mockCart) {
      await Future.delayed(const Duration(milliseconds: 800));
      // _cartItems = List.from(MockData.cartItems);
      _isLoading = false;
      notifyListeners();
      return;
    }

    // 2. Gọi API thật
    final response = await _cartService.getCart();

    if (response != null) {
      // Cập nhật toàn bộ trạng thái giỏ hàng từ Server
      _cartItems = response.items;
      _serverTotalPrice = response.totalPrice;
    } else {
      // Nếu có lỗi (VD: Mất mạng), reset giỏ hàng về rỗng
      _cartItems = [];
      _serverTotalPrice = 0;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> increaseQuantity(int cartItemId) async {
    // 1. Tìm item trong list local
    final index = _cartItems.indexWhere(
      (item) => item.cartItemId == cartItemId,
    );
    if (index == -1) return;

    final currentItem = _cartItems[index];
    final newQuantity = currentItem.quantity + 1;

    // Lấy productId từ item hiện tại
    final productId = currentItem.productId;

    // Mock logic
    if (AppConfig.mockCart) {
      _cartItems[index].quantity = newQuantity;
      notifyListeners();
      return;
    }

    // API Logic
    _isLoading = true;
    notifyListeners();

    // Gọi Service truyền vào productId
    final response = await _cartService.updateCartItem(productId, newQuantity);

    if (response != null) {
      _cartItems = response.items;
      _serverTotalPrice = response.totalPrice;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Giảm số lượng
  Future<void> decreaseQuantity(int cartItemId) async {
    final index = _cartItems.indexWhere(
      (item) => item.cartItemId == cartItemId,
    );
    if (index == -1) return;

    final currentItem = _cartItems[index];
    if (currentItem.quantity <= 1) return;

    final newQuantity = currentItem.quantity - 1;
    final productId = currentItem.productId; // Lấy productId

    // Mock logic
    if (AppConfig.mockCart) {
      _cartItems[index].quantity = newQuantity;
      notifyListeners();
      return;
    }

    // API Logic
    _isLoading = true;
    notifyListeners();

    // Gọi Service truyền vào productId
    final response = await _cartService.updateCartItem(productId, newQuantity);

    if (response != null) {
      _cartItems = response.items;
      _serverTotalPrice = response.totalPrice;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Xóa sản phẩm
  Future<void> removeItem(int cartItemId) async {
    // 1. Tìm item trong danh sách để lấy ProductId
    final index = _cartItems.indexWhere(
      (item) => item.cartItemId == cartItemId,
    );
    if (index == -1) return;

    final productId = _cartItems[index].productId;

    // Logic Mock
    if (AppConfig.mockCart) {
      _cartItems.removeAt(index);
      notifyListeners();
      return;
    }

    // Logic API Thật
    _isLoading = true;
    notifyListeners();

    final response = await _cartService.removeCartItem(productId);

    // --- SỬA ĐOẠN NÀY ---
    if (response != null) {
      // Thay vì thay thế cả list (_cartItems = ...), ta chỉ xóa item hiện tại
      _cartItems.removeWhere((item) => item.cartItemId == cartItemId);

      // Mẹo: Vì API remove có thể trả về totalPrice = 0 (như ví dụ bạn đưa),
      // nên để an toàn nhất, sau khi xóa xong ta nên gọi lại loadCart() để đồng bộ chuẩn xác
      // hoặc nếu bạn muốn nhanh thì giữ nguyên việc xóa local,
      // nhưng nhớ là totalAmount sẽ được tính lại dựa trên _cartItems còn lại (nhờ getter totalAmount).

      // Cập nhật lại _serverTotalPrice nếu API trả về đúng,
      // còn nếu API trả về 0 thì ta reset biến này để getter totalAmount tự tính toán lại
      if (response.totalPrice > 0) {
        _serverTotalPrice = response.totalPrice;
      } else {
        _serverTotalPrice = 0; // Để getter tự tính lại dựa trên list còn lại
      }
    }
    // --------------------

    _isLoading = false;
    notifyListeners();
  }

  // Xóa sạch giỏ hàng (chỉ xóa local)
  void clearCart() {
    _cartItems = [];
    _serverTotalPrice = 0;
    notifyListeners();
  }
}
