import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';
import '../../../configs/app_config.dart';

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

    // Logic Mock (Nếu đang bật)
    if (AppConfig.mockProductList) {
      // ... code mock cũ ...
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Logic API Thật
    try {
      if (keyword != null && keyword.isNotEmpty) {
        // A. Tìm kiếm
        _products = await _productService.searchProducts(keyword);
      } else if (categoryId != null) {
        // --- B. LỌC THEO DANH MỤC (Logic mới thêm vào) ---
        _products = await _productService.getProductsByCategory(categoryId);
      } else {
        // C. Lấy tất cả (Mặc định)
        _products = await _productService.getProducts();
      }
    } catch (e) {
      print("Lỗi Load Data: $e");
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
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
