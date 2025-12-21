import 'package:flutter/material.dart';
import '../../../data/models/category_model.dart';
import '../../../data/services/category_service.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService _service = CategoryService();

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _service.getCategories();
    } catch (e) {
      print("Error loading categories: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
