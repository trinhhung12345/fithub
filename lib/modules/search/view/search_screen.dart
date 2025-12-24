import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart';
import '../../../core/components/fit_hub_button.dart';
import '../../../core/components/home_search_bar.dart';
import '../../category/view_model/category_view_model.dart'; // Import ViewModel
import '../../product/view/product_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isNotFound = false;

  @override
  void initState() {
    super.initState();
    // Gọi API lấy danh mục (nếu chưa có data)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<CategoryViewModel>();
      if (viewModel.categories.isEmpty) {
        viewModel.fetchCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Header: Back + SearchBar
              Row(
                children: [
                  const FitHubBackButton(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: HomeSearchBar(
                      hintText: "Search",
                      onChanged: (val) {
                        // Reset trạng thái not found khi gõ
                        if (_isNotFound) setState(() => _isNotFound = false);
                      },
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          // Chuyển sang trang kết quả tìm kiếm
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductListScreen(
                                title: value,
                                keyword: value,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Nội dung chính
              Expanded(
                child: _isNotFound
                    ? _buildNotFound()
                    : _buildCategories(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Giao diện Shop by Categories (Dữ liệu thật từ API)
  Widget _buildCategories(BuildContext context) {
    // Lắng nghe ViewModel
    final categoryViewModel = context.watch<CategoryViewModel>();
    final categories = categoryViewModel.categories;

    if (categoryViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categories.isEmpty) {
      return const Center(child: Text("Không có danh mục nào"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Shop by Categories",
          style: AppTextStyles.h2.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final category = categories[index];

              return GestureDetector(
                onTap: () {
                  // Chuyển sang trang danh sách sản phẩm theo danh mục này
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductListScreen(
                        title: category.name,
                        categoryId: category.id,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4), // Màu xám nhạt
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Icon từ Assets (Đã map trong CategoryModel)
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Image.asset(
                          category.iconPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Tên danh mục từ API
                      Expanded(
                        child: Text(
                          category.name, // Ví dụ: "Túi", "Giày", "Phụ kiện"
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Giao diện Không tìm thấy (Giữ nguyên)
  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search, size: 50, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          const Text(
            "Sorry, we couldn't find any\nmatching result for your\nSearch.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
