import 'package:flutter/material.dart';
import '../../../configs/app_config.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';

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

    // Gọi Service (Service sẽ tự quyết định dùng Mock hay API dựa vào Config)
    // Lưu ý: Cần khởi tạo service: final ProductService _service = ProductService();
    // Hoặc nếu bạn đã inject service thì dùng nó.

    // Code cũ của bạn có thể đang fix cứng Mock, hãy sửa thành gọi Service:
    _product = await ProductService().getProductDetail(id);

    // --- QUAN TRỌNG: TRỘN DỮ LIỆU ---
    // Vì API chưa trả về Ảnh và Review, ta vẫn phải lấy từ MockData
    // để giao diện không bị trống trơn.
    if (_product != null) {
      _reviews = List.from(MockData.reviews); // Lấy review giả
      // Ảnh giả đã được xử lý trong Model Product.imageUrl rồi
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
