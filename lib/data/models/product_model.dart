import 'package:intl/intl.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final ProductCategory? category;
  final String? _mockImage; // Giữ lại để hiện ảnh giả vì API chưa có ảnh

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
    // Xử lý Category: API list trả về object, API detail trả về field rời
    ProductCategory? cat;
    if (json['category'] != null) {
      cat = ProductCategory.fromJson(json['category']);
    } else if (json['categoryId'] != null) {
      cat = ProductCategory(
        id: json['categoryId'],
        name: json['categoryName'] ?? "",
      );
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Sản phẩm chưa đặt tên",
      description: json['description'] ?? "",
      // Xử lý an toàn cho cả int và double
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      category: cat,
      // API chưa có ảnh -> Logic ảnh giả
      mockImage: null,
    );
  }

  // --- Helpers cho UI (Giữ nguyên) ---
  String get imageUrl {
    if (_mockImage != null) return _mockImage!;

    // Logic random ảnh dựa trên tên (để demo cho đẹp)
    if (name.toLowerCase().contains("iphone")) {
      return "https://cdn.tgdd.vn/Products/Images/42/305658/iphone-15-pro-max-blue-titan-1-750x500.jpg";
    }
    if (name.toLowerCase().contains("cáp") ||
        name.toLowerCase().contains("sạc")) {
      return "https://cdn.tgdd.vn/Products/Images/58/236016/cap-type-c-1m-anker-a8023-trang-thumb-600x600.jpeg";
    }
    if (name.toLowerCase().contains("samsung")) {
      return "https://cdn.tgdd.vn/Products/Images/42/307174/samsung-galaxy-s24-ultra-grey-1-750x500.jpg";
    }
    return "https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/9769966c-54a4-4bf8-b543-96b66e30b057/m-j-ess-flc-short-x-ma-bQWvj1.png";
  }

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
