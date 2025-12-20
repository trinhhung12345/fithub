import 'product_model.dart';

class CartItem {
  final int id; // ID của dòng trong giỏ hàng (khác ProductId)
  final Product product;
  int quantity;

  CartItem({required this.id, required this.product, this.quantity = 1});

  // Tính tổng tiền của item này
  double get totalPrice => product.price * quantity;
}
