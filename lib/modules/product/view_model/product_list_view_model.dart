import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';

class ProductListViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _originalProducts = []; // Lưu lại list gốc để filter

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Hàm load sản phẩm (cũ - giữ lại để tương thích)
  Future<void> getProducts() async {
    await loadData();
  }

  // Hàm load sản phẩm mới với filter
  Future<void> loadData({String? keyword, int? categoryId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Tạm thời gọi API lấy tất cả (sau này có thể truyền categoryId vào đây để lọc)
      _products = await _productService.getProducts();
      _originalProducts = List.from(_products); // Backup list gốc

      // Nếu có keyword, lọc theo tên (Mock logic)
      if (keyword != null && keyword.isNotEmpty) {
        _products = _products
            .where((p) => p.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
        _originalProducts = List.from(_products);
      }

      // Nếu có categoryId, lọc theo category (Mock logic - cần thêm categoryId vào Product model)
      // if (categoryId != null) {
      //   _products = _products.where((p) => p.categoryId == categoryId).toList();
      // }
    } catch (e) {
      print("Lỗi load danh sách: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Hàm Sort
  void sortProducts(String option) {
    if (option == "Lowest - Highest Price") {
      _products.sort((a, b) => a.price.compareTo(b.price));
    } else if (option == "Highest - Lowest Price") {
      _products.sort((a, b) => b.price.compareTo(a.price));
    } else {
      // Newest / Recommended: Reset về list gốc (Mock thôi)
      _products = List.from(_originalProducts);
    }
    notifyListeners();
  }

  // Hàm Filter Price
  void filterPrice(double? min, double? max) {
    _products = _originalProducts.where((p) {
      if (min != null && p.price < min) return false;
      if (max != null && p.price > max) return false;
      return true;
    }).toList();
    notifyListeners();
  }
}
