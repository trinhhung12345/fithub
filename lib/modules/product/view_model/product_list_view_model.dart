import 'package:flutter/material.dart';
import '../../../configs/app_config.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';

class ProductListViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  // Danh sách hiển thị lên UI
  List<Product> _products = [];
  List<Product> get products => _products;

  // Danh sách GỐC (Backup để Reset)
  List<Product> _originalProducts = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Trạng thái bộ lọc hiện tại
  String _currentSort = "Recommended"; // Default
  double? _minPrice;
  double? _maxPrice;

  // Getter để UI biết đang lọc gì
  String get currentSort => _currentSort;
  bool get isFiltered =>
      _minPrice != null || _maxPrice != null || _currentSort != "Recommended";

  // -------------------------------------------------------
  // 1. LOAD DATA TỪ API (GIỮ NGUYÊN LOGIC CŨ)
  // -------------------------------------------------------
  Future<void> loadData({String? keyword, int? categoryId}) async {
    _isLoading = true;
    notifyListeners();

    // Reset bộ lọc mỗi khi load trang mới
    _resetFilterState();

    try {
      List<Product> fetchedData = [];

      if (AppConfig.mockProductList) {
        // Logic Mock (nếu config bật)
        // ... (Code mock cũ) ...
      } else {
        // Logic API Thật
        if (keyword != null && keyword.isNotEmpty) {
          fetchedData = await _productService.searchProducts(keyword);
        } else if (categoryId != null) {
          fetchedData = await _productService.getProductsByCategory(categoryId);
        } else {
          fetchedData = await _productService.getProducts();
        }
      }

      // LƯU DATA VÀO CẢ 2 LIST
      _originalProducts = fetchedData;
      _products = List.from(_originalProducts); // Copy sang list hiển thị
    } catch (e) {
      print("Lỗi Load Data: $e");
      _products = [];
      _originalProducts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // -------------------------------------------------------
  // 2. LOGIC LỌC & SẮP XẾP (CLIENT SIDE)
  // -------------------------------------------------------

  // Hàm set Sort
  void setSortFilter(String sortOption) {
    _currentSort = sortOption;
    _applyLocalFilters();
  }

  // Hàm set Price
  void setPriceFilter(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    _applyLocalFilters();
  }

  // Hàm Reset
  void resetFilters() {
    _resetFilterState();
    _applyLocalFilters();
  }

  // Helper reset biến
  void _resetFilterState() {
    _currentSort = "Recommended";
    _minPrice = null;
    _maxPrice = null;
  }

  // --- HÀM XỬ LÝ TRUNG TÂM ---
  void _applyLocalFilters() {
    // B1: Reset list hiển thị về list gốc
    List<Product> temp = List.from(_originalProducts);

    // B2: Lọc theo Giá (Filter)
    if (_minPrice != null || _maxPrice != null) {
      temp = temp.where((p) {
        if (_minPrice != null && p.price < _minPrice!) return false;
        if (_maxPrice != null && p.price > _maxPrice!) return false;
        return true;
      }).toList();
    }

    // B3: Sắp xếp (Sort)
    switch (_currentSort) {
      case "Lowest - Highest Price":
        temp.sort((a, b) => a.price.compareTo(b.price));
        break;
      case "Highest - Lowest Price":
        temp.sort((a, b) => b.price.compareTo(a.price));
        break;
      case "Newest":
        // Giả sử xếp theo ID giảm dần nếu không có field createdAt chuẩn
        temp.sort((a, b) => b.id.compareTo(a.id));
        break;
      case "Recommended":
      default:
        // Không sort gì cả (giữ nguyên thứ tự API hoặc list gốc)
        break;
    }

    // B4: Cập nhật UI
    _products = temp;
    notifyListeners();
  }
}
