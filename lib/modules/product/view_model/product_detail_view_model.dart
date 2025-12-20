import 'package:flutter/material.dart';
import '../../../configs/app_config.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/product_model.dart';

class ProductDetailViewModel extends ChangeNotifier {
  Product? _product;
  Product? get product => _product;

  int _quantity = 1;
  int get quantity => _quantity;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Giả lập số liệu Backend chưa có
  int get soldCount => 90; // "Đã bán" (Mock)
  List<String> get images => MockData.detailImages; // Ảnh (Mock)

  // Biến chứa danh sách review (ban đầu lấy từ Mock)
  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> get reviews => _reviews;

  Future<void> loadProductDetail(int id) async {
    _isLoading = true;
    notifyListeners();

    if (AppConfig.mockProductDetail) {
      await Future.delayed(const Duration(seconds: 1)); // Giả vờ load
      _product = MockData.productDetail; // Lấy từ Mock

      // COPY danh sách từ Mock ra để có thể chỉnh sửa (add thêm)
      _reviews = List.from(MockData.reviews);
    } else {
      // Sau này gọi API thật ở đây
      // _product = await _service.getProductDetail(id);
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- HÀM MOCK THÊM ĐÁNH GIÁ ---
  void addReview(int rating, String content) {
    // Tạo một object review giả
    final newReview = {
      "name": "Bạn (Tôi)", // Tên người dùng hiện tại
      "avatar": "https://i.pravatar.cc/150?img=12", // Avatar giả
      "rating": rating,
      "date": "Vừa xong", // Thời gian
      "content": content,
    };

    // Thêm vào đầu danh sách
    _reviews.insert(0, newReview);

    // Cập nhật UI
    notifyListeners();
  }

  void increaseQuantity() {
    // Không cho tăng quá số lượng tồn kho
    if (_product != null && _quantity < _product!.stock) {
      _quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }
}
