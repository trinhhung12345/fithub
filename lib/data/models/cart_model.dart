import 'product_model.dart';

class CartItem {
  final int cartItemId; // ID của dòng trong giỏ (API trả về là cartItemId)
  final int productId;
  // Để tái sử dụng ProductCard cũ, ta vẫn giữ object Product,
  // nhưng sẽ tạo nó từ các trường rời rạc của API
  final Product product;
  int quantity;
  final double totalPrice; // API tính sẵn cho mình

  CartItem({
    required this.cartItemId,
    required this.productId,
    required this.product,
    required this.quantity,
    this.totalPrice = 0,
  });

  // Map từ JSON API trả về
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartItemId: json['cartItemId'] ?? 0,
      productId: json['productId'] ?? 0,
      quantity: json['quantity'] ?? 1,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),

      // TẠO PRODUCT GIẢ LẬP
      product: Product(
        id: json['productId'] ?? 0,
        name: json['productName'] ?? "Sản phẩm",
        description: "",
        price: (json['productPrice'] ?? 0).toDouble(),
        stock: 999,

        // --- THÊM DÒNG NÀY ĐỂ FIX LỖI ---
        active: true, // Mặc định là true vì API Cart không trả về field này
        // -------------------------------
      ),
    );
  }
}

// Class bao bọc cả phản hồi (để hứng totalQuantity, totalPrice tổng)
class CartResponse {
  final int cartId;
  final double totalPrice;
  final int totalQuantity;
  final List<CartItem> items;

  CartResponse({
    required this.cartId,
    required this.totalPrice,
    required this.totalQuantity,
    required this.items,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List? ?? [];
    List<CartItem> itemsList = list.map((i) => CartItem.fromJson(i)).toList();

    return CartResponse(
      cartId: json['cartId'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      totalQuantity: json['totalQuantity'] ?? 0,
      items: itemsList,
    );
  }
}
