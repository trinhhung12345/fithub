import 'package:intl/intl.dart';

class ProductTag {
  final int id;
  final String name;
  final String type; // Ví dụ: SHOES, BAG, THE LUC...

  ProductTag({required this.id, required this.name, required this.type});

  factory ProductTag.fromJson(Map<String, dynamic> json) {
    return ProductTag(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      type: json['type'] ?? "",
    );
  }
}

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
  final List<ProductTag> tags;
  final String? _mockImage;
  final bool active;

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
    this.tags = const [],
    String? mockImage,
    required this.active,
  }) : _mockImage = mockImage;

  factory Product.fromJson(Map<String, dynamic> json) {
    // Xử lý Category (Giữ nguyên logic cũ)
    ProductCategory? cat;
    if (json['category'] != null) {
      cat = ProductCategory.fromJson(json['category']);
    } else if (json['categoryId'] != null) {
      cat = ProductCategory(
        id: json['categoryId'],
        name: json['categoryName'] ?? "",
      );
    }

    // Xử lý Files (Giữ nguyên)
    var listFiles = json['files'] as List? ?? [];
    List<ProductFile> productFiles = listFiles
        .map((f) => ProductFile.fromJson(f))
        .toList();

    // --- XỬ LÝ TAGS (MỚI) ---
    var listTags = json['tags']; // Lấy raw data
    List<ProductTag> productTags = [];

    // Kiểm tra kỹ vì API có thể trả về null (như product id 19)
    if (listTags != null && listTags is List) {
      productTags = listTags.map((t) => ProductTag.fromJson(t)).toList();
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Sản phẩm chưa đặt tên",
      description: json['description'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      category: cat,
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      files: productFiles,
      tags: productTags, // <-- Gán vào model
      mockImage: null,
      active: json['active'] ?? false,
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
