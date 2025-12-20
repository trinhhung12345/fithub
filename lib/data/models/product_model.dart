import 'package:intl/intl.dart'; // Dùng để format tiền tệ

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final ProductCategory? category;
  // API chưa có ảnh, mình thêm biến này để xử lý UI
  final String? _mockImage;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.category,
    String? mockImage,
  }) : _mockImage = mockImage;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Sản phẩm chưa đặt tên",
      description: json['description'] ?? "",
      // Xử lý an toàn: API có thể trả về int hoặc double
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      category: json['category'] != null
          ? ProductCategory.fromJson(json['category'])
          : null,
    );
  }

  // --- Helpers cho UI ---

  // 1. Getter lấy ảnh (Tạm thời trả về ảnh demo nếu API không có)
  String get imageUrl {
    // Nếu tên chứa "iPhone" trả về ảnh điện thoại, ngược lại ảnh mặc định
    if (name.toLowerCase().contains("iphone")) {
      return "https://cdn.tgdd.vn/Products/Images/42/305658/iphone-15-pro-max-blue-titan-1-750x500.jpg";
    }
    if (name.toLowerCase().contains("samsung")) {
      return "https://cdn.tgdd.vn/Products/Images/42/307174/samsung-galaxy-s24-ultra-grey-1-750x500.jpg";
    }
    // Ảnh mặc định cho dụng cụ tập gym
    return "https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/9769966c-54a4-4bf8-b543-96b66e30b057/m-j-ess-flc-short-x-ma-bQWvj1.png";
  }

  // 2. Getter format giá tiền (Ví dụ: 34,990,000 đ)
  String get formattedPrice {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatCurrency.format(price);
  }
}

class ProductCategory {
  final int id;
  final String name;

  ProductCategory({required this.id, required this.name});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(id: json['id'] ?? 0, name: json['name'] ?? "");
  }
}
