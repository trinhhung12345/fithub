import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';

class HomeViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Hàm khởi chạy ban đầu
  Future<void> init() async {
    await fetchProducts();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productService.getProducts();

      // --- THÊM DÒNG NÀY ĐỂ RANDOM ---
      // Xáo trộn vị trí các phần tử trong list
      _products.shuffle();
      // -------------------------------
    } catch (e) {
      _errorMessage = "Không thể tải sản phẩm: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
