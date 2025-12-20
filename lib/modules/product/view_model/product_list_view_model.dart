import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';

class ProductListViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  List<Product> get products => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Hàm load sản phẩm
  Future<void> getProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Tạm thời gọi API lấy tất cả (sau này có thể truyền categoryId vào đây để lọc)
      _products = await _productService.getProducts();
    } catch (e) {
      print("Lỗi load danh sách: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
