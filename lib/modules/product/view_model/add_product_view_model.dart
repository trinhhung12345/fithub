import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/product_service.dart';

class AddProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Danh sách ảnh đã chọn
  List<File> _selectedImages = [];
  List<File> get selectedImages => _selectedImages;

  // Hàm chọn ảnh từ thư viện
  Future<void> pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      _selectedImages.addAll(pickedFiles.map((e) => File(e.path)).toList());
      notifyListeners();
    }
  }

  // Hàm xóa ảnh khỏi danh sách chọn
  void removeImage(int index) {
    _selectedImages.removeAt(index);
    notifyListeners();
  }

  // Hàm Submit
  Future<bool> submitProduct({
    required String name,
    required String desc,
    required String price,
    required String stock,
    required String categoryId,
  }) async {
    _isLoading = true;
    notifyListeners();

    final success = await _productService.addProduct(
      name: name,
      description: desc,
      price: double.tryParse(price) ?? 0,
      stock: int.tryParse(stock) ?? 0,
      categoryId: int.tryParse(categoryId) ?? 1, // Default ID 1
      images: _selectedImages,
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
