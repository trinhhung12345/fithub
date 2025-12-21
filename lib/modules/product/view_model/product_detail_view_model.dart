import 'package:flutter/material.dart';
import '../../../configs/app_config.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';

import '../../../data/services/review_service.dart';
import '../../../core/utils/token_utils.dart';

class ProductDetailViewModel extends ChangeNotifier {
  Product? _product;
  Product? get product => _product;

  int _quantity = 1;
  int get quantity => _quantity;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Giả lập số liệu Backend chưa có
  int get soldCount => 90; // "Đã bán" (Mock)

  // Biến chứa danh sách review (ban đầu lấy từ Mock)
  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> get reviews => _reviews;
  final ReviewService _reviewService = ReviewService();

  List<String> _displayImages = [];
  List<String> get images => _displayImages;

  Future<void> loadProductDetail(int id) async {
    _isLoading = true;
    notifyListeners();

    // 1. Load thông tin sản phẩm (API Detail)
    _product = await ProductService().getProductDetail(id);

    // 2. Cập nhật danh sách ảnh hiển thị
    if (_product != null) {
      if (_product!.files.isNotEmpty) {
        // Nếu API có ảnh -> Map sang List String url
        _displayImages = _product!.files.map((f) => f.originUrl).toList();
      } else {
        // Nếu API chưa có ảnh -> Dùng ảnh đại diện hoặc mock list
        _displayImages = [_product!.imageUrl];
      }
    }

    // 3. Load đánh giá (API Review)
    // Dù có mockProductDetail hay không, ta cứ gọi thử API review xem sao
    // Nếu bạn muốn tắt hẳn Mock thì xóa cái if (AppConfig...) đi
    if (!AppConfig.mockProductDetail) {
      try {
        final apiReviews = await _reviewService.getProductReviews(id);

        // --- CHUYỂN ĐỔI DỮ LIỆU ĐỂ KHỚP VỚI UI CŨ ---
        _reviews = apiReviews.map((r) {
          return {
            "id": r.id, // <-- QUAN TRỌNG: Lưu reviewId
            "userId": r.userId, // <-- QUAN TRỌNG: Lưu userId để đối chiếu
            "name": "User #${r.userId}",
            "avatar": "https://i.pravatar.cc/150?u=${r.userId}",
            "rating": r.rating,
            "date": "Mới đây",
            "content": r.comment,
          };
        }).toList();
      } catch (e) {
        print("Lỗi load review: $e");
        _reviews = [];
      }
    } else {
      // Logic Mock cũ
      _reviews = List.from(MockData.reviews);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> addReview(int rating, String comment) async {
    if (_product == null) return "Lỗi sản phẩm";

    _isLoading = true;
    notifyListeners();

    // 1. Gọi Service
    final result = await _reviewService.createReview(
      productId: _product!.id,
      rating: rating,
      comment: comment,
    );

    _isLoading = false;
    notifyListeners();

    if (result['success'] == true) {
      // 2. Nếu thành công:
      // Cách A (An toàn nhất): Load lại toàn bộ detail để lấy list review mới từ server
      // await loadProductDetail(_product!.id);

      // Cách B (Nhanh, UX tốt): Tự tạo review giả chèn vào đầu list (để ko phải load lại API)
      // Vì API post xong không trả về object Review vừa tạo, ta tự chế tạm để hiển thị ngay
      final newReview = {
        "name": "Bạn (Vừa xong)",
        "avatar": "https://i.pravatar.cc/150?u=me", // Avatar tạm
        "rating": rating,
        "date": "Vừa xong",
        "content": comment,
      };
      _reviews.insert(0, newReview);
      notifyListeners();

      return null; // Null nghĩa là không có lỗi
    } else {
      // 3. Nếu thất bại (VD: Đã review rồi)
      return result['message']; // Trả về câu thông báo lỗi
    }
  }

  Future<String?> editMyReview(int rating, String comment) async {
    if (_product == null) return "Lỗi sản phẩm";

    // 1. Lấy userId hiện tại
    final currentUserId = await TokenUtils.getUserId();
    if (currentUserId == null) return "Bạn cần đăng nhập";

    // 2. Tìm bài đánh giá của tôi trong danh sách đã load
    // Điều kiện: userId trong review trùng với userId đăng nhập
    final myReviewIndex = _reviews.indexWhere(
      (r) => r['userId'] == currentUserId,
    );

    if (myReviewIndex == -1) {
      // Trường hợp hiếm: API báo đã review nhưng load list không thấy (hoặc chưa load lại)
      // Thử reload lại page để lấy ID mới nhất
      await loadProductDetail(_product!.id);
      return "Vui lòng thử lại lần nữa (đã đồng bộ dữ liệu)";
    }

    final reviewId = _reviews[myReviewIndex]['id']; // Lấy ID bài đánh giá

    _isLoading = true;
    notifyListeners();

    // 3. Gọi Service với reviewId
    final result = await _reviewService.updateReview(
      reviewId: reviewId, // <-- Truyền ID bài đánh giá
      rating: rating,
      comment: comment,
    );

    _isLoading = false;
    notifyListeners();

    if (result['success'] == true) {
      await loadProductDetail(_product!.id); // Reload để hiện nội dung mới
      return null;
    } else {
      return result['message'];
    }
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
