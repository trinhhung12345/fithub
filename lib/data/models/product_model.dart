import 'package:intl/intl.dart';

// 1. Class hứng từng file ảnh
class ProductFile {
  final int id;
  final String originUrl;
  final String? thumbUrl; // Thêm nếu cần dùng sau này

  ProductFile({required this.id, required this.originUrl, this.thumbUrl});

  factory ProductFile.fromJson(Map<String, dynamic> json) {
    return ProductFile(
      id: json['id'] ?? 0,
      originUrl: json['originUrl'] ?? "",
      thumbUrl: json['thumbUrl'],
    );
  }
}

// 2. Class Product chính
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final ProductCategory? category; // Object lồng (dùng cho list)
  final int? categoryId; // Field rời (dùng cho detail)
  final String? categoryName; // Field rời (dùng cho detail)
  final List<ProductFile> files; // Danh sách ảnh thật
  final String? _mockImage;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    this.category,
    this.categoryId,
    this.categoryName,
    this.files = const [],
    String? mockImage,
  }) : _mockImage = mockImage;

  factory Product.fromJson(Map<String, dynamic> json) {
    // Xử lý Category (Hỗ trợ cả 2 kiểu response của API)
    ProductCategory? cat;
    if (json['category'] != null) {
      cat = ProductCategory.fromJson(json['category']);
    } else if (json['categoryId'] != null) {
      // Nếu API trả về field rời, ta gom lại thành object Category để UI dễ dùng
      cat = ProductCategory(
        id: json['categoryId'],
        name: json['categoryName'] ?? "",
      );
    }

    // Xử lý Files
    var listFiles = json['files'] as List? ?? [];
    List<ProductFile> productFiles = listFiles
        .map((f) => ProductFile.fromJson(f))
        .toList();

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Sản phẩm chưa đặt tên",
      description: json['description'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      category: cat,
      // Lưu lại các field rời phòng khi cần
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      files: productFiles,
      mockImage: null,
    );
  }

  // Helper lấy ảnh đại diện (cho Product Card)
  String get imageUrl {
    if (files.isNotEmpty) return files.first.originUrl;
    if (_mockImage != null) return _mockImage!;
    // Fallback ảnh mặc định...
    return "https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/9769966c-54a4-4bf8-b543-96b66e30b057/m-j-ess-flc-short-x-ma-bQWvj1.png";
  }

  // Helper format tiền
  String get formattedPrice {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    return formatCurrency.format(price);
  }
}

class ProductCategory {
  final int id;
  final String name;
  ProductCategory({required this.id, required this.name});
  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(id: json['id'] ?? 0, name: json['name'] ?? "");
}
