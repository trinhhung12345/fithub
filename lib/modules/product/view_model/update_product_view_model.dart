import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/product_service.dart';

class UpdateProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // List hỗn hợp: Chứa String (URL cũ) hoặc File (Ảnh mới)
  List<dynamic> _currentImages = [];
  List<dynamic> get currentImages => _currentImages;

  // Load dữ liệu từ sản phẩm có sẵn vào form
  void initData(Product product) {
    // Lấy danh sách URL từ product.files
    if (product.files.isNotEmpty) {
      _currentImages = List<dynamic>.from(
        product.files.map((f) => f.originUrl),
      );
    } else {
      // Nếu sản phẩm cũ chưa có file, thử lấy ảnh đại diện
      _currentImages = List<dynamic>.from([product.imageUrl]);
    }
    notifyListeners();
  }

  // Chọn ảnh mới
  Future<void> pickNewImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      // Thêm File vào danh sách
      _currentImages.addAll(pickedFiles.map((e) => File(e.path)).toList());
      notifyListeners();
    }
  }

  // Xóa ảnh (Dù cũ hay mới cũng xóa khỏi list)
  void removeImage(int index) {
    _currentImages.removeAt(index);
    notifyListeners();
  }

  // Submit Update
  Future<bool> updateProduct({
    required int id,
    required String name,
    required String desc,
    required String price,
    required String stock,
    required String categoryId,
  }) async {
    _isLoading = true;
    notifyListeners();

    final success = await _productService.updateProduct(
      id: id,
      name: name,
      description: desc,
      price: double.tryParse(price) ?? 0,
      stock: int.tryParse(stock) ?? 0,
      categoryId: int.tryParse(categoryId) ?? 1,
      finalImages: _currentImages, // Gửi list hỗn hợp xuống Service xử lý
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
