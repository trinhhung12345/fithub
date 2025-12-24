import 'package:flutter/material.dart';
import '../../../configs/app_config.dart';
import '../../../core/utils/token_utils.dart';
import '../../../data/mock/mock_data.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';
import '../../../data/services/review_service.dart';

class ProductDetailViewModel extends ChangeNotifier {
  // Services
  final ProductService _productService = ProductService();
  final ReviewService _reviewService = ReviewService();

  // State Variables
  Product? _product;
  Product? get product => _product;

  int _quantity = 1;
  int get quantity => _quantity;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Danh sách ảnh hiển thị trên Carousel
  List<String> _displayImages = [];
  List<String> get images => _displayImages;

  // Danh sách đánh giá (Mapped sang dạng Map để UI dễ hiển thị)
  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> get reviews => _reviews;

  // Review của người dùng hiện tại (nếu có)
  Map<String, dynamic>? _myReview;
  Map<String, dynamic>? get myReview => _myReview;

  // Getter kiểm tra đã đánh giá chưa
  bool get hasReviewed => _myReview != null;

  // Giả lập số liệu "Đã bán" (Vì API chưa có)
  int get soldCount => 90;

  // ---------------------------------------------------------
  // 1. LOAD DỮ LIỆU (CHI TIẾT + REVIEW)
  // ---------------------------------------------------------
  Future<void> loadProductDetail(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // A. Gọi API lấy thông tin sản phẩm
      _product = await _productService.getProductDetail(id);

      if (_product != null) {
        // --- XỬ LÝ ẢNH ---
        if (_product!.files.isNotEmpty) {
          // Lấy danh sách ảnh thật từ Cloudinary
          _displayImages = _product!.files.map((f) => f.originUrl).toList();
        } else {
          // Fallback: Dùng ảnh đại diện hoặc Mock
          _displayImages = [_product!.imageUrl];
        }

        // --- XỬ LÝ REVIEW ---
        // Lấy ID người dùng hiện tại để check xem đã review chưa
        final currentUserId = await TokenUtils.getUserId();

        if (!AppConfig.mockProductDetail) {
          // Gọi API thật
          final apiReviews = await _reviewService.getProductReviews(id);

          // Map từ Model Review sang Map cho UI
          _reviews = apiReviews.map((r) {
            return {
              "id": r.id, // ID bài review (quan trọng để update)
              "userId": r.userId, // ID người viết (quan trọng để check owner)
              "name": "User #${r.userId}", // Tạm thời fake tên
              "avatar":
                  "https://i.pravatar.cc/150?u=${r.userId}", // Fake avatar
              "rating": r.rating,
              "date": "Mới đây",
              "content": r.comment,
            };
          }).toList();
        } else {
          // Dùng Mock Data
          _reviews = List.from(MockData.reviews);
        }

        // --- TÌM REVIEW CỦA TÔI ---
        _myReview = null; // Reset trước
        if (currentUserId != null && _reviews.isNotEmpty) {
          try {
            // Tìm review nào có userId khớp với token
            final myReviewData = _reviews.firstWhere(
              (r) => r['userId'] == currentUserId,
            );
            _myReview = myReviewData;
          } catch (e) {
            // Không tìm thấy -> Chưa review
            _myReview = null;
          }
        }
      }
    } catch (e) {
      print("Lỗi loadProductDetail: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // ---------------------------------------------------------
  // 2. LOGIC SỐ LƯỢNG (QUANTITY)
  // ---------------------------------------------------------
  void increaseQuantity() {
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

  // ---------------------------------------------------------
  // 3. LOGIC ĐÁNH GIÁ (ADD & UPDATE)
  // ---------------------------------------------------------

  // Thêm đánh giá mới (POST)
  Future<String?> addReview(int rating, String comment) async {
    if (_product == null) return "Lỗi sản phẩm";

    _isLoading = true;
    notifyListeners();

    final result = await _reviewService.createReview(
      productId: _product!.id,
      rating: rating,
      comment: comment,
    );

    _isLoading = false;
    notifyListeners();

    if (result['success'] == true) {
      // Reload lại để cập nhật danh sách và set _myReview chuẩn xác từ server
      await loadProductDetail(_product!.id);
      return null; // Thành công
    } else {
      return result['message']; // Trả về lỗi
    }
  }

  // Cập nhật đánh giá cũ (PUT)
  Future<String?> editMyReview(int rating, String comment) async {
    if (_product == null) return "Lỗi sản phẩm";
    if (_myReview == null) return "Không tìm thấy đánh giá cũ";

    final reviewId = _myReview!['id']; // Lấy ID bài đánh giá

    _isLoading = true;
    notifyListeners();

    final result = await _reviewService.updateReview(
      reviewId: reviewId,
      rating: rating,
      comment: comment,
    );

    _isLoading = false;
    notifyListeners();

    if (result['success'] == true) {
      // Reload lại để cập nhật nội dung mới
      await loadProductDetail(_product!.id);
      return null; // Thành công
    } else {
      return result['message']; // Trả về lỗi
    }
  }
}
