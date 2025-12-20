import 'package:flutter/material.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart';
import '../../../core/components/fit_hub_button.dart';
import '../../../core/components/home_search_bar.dart';
import '../../product/view/product_list_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Danh sách danh mục gợi ý
  final categories = ["Hoodies", "Accessories", "Shorts", "Shoes", "Bags"];
  final images = [
    "https://cdn-icons-png.flaticon.com/512/9310/9310069.png", // Hoodie icon
    "https://cdn-icons-png.flaticon.com/512/2806/2806166.png", // Glasses
    "https://cdn-icons-png.flaticon.com/512/2275/2275496.png", // Shorts
    "https://cdn-icons-png.flaticon.com/512/2589/2589903.png", // Shoes
    "https://cdn-icons-png.flaticon.com/512/2855/2855845.png", // Bag
  ];

  bool _isNotFound = false; // Biến test trạng thái "Không tìm thấy"

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
                        // Logic test: Gõ "ao" thì hiện, gõ "xyz" thì báo lỗi
                        setState(() {
                          _isNotFound = val.contains("xyz");
                        });
                      },
                      // Quan trọng: Khi bấm Enter -> Chuyển sang ProductListScreen
                      onSubmitted: (value) {
                        if (value.isNotEmpty && !_isNotFound) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductListScreen(
                                title: value, // Title là từ khóa
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
                child: _isNotFound ? _buildNotFound() : _buildCategories(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Giao diện Shop by Categories (Ảnh 1)
  Widget _buildCategories() {
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
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.network(images[index], width: 40, height: 40),
                    const SizedBox(width: 16),
                    Text(
                      categories[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Giao diện Không tìm thấy (Ảnh 2)
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
            child: Icon(Icons.search, size: 50, color: AppColors.primary),
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
          const SizedBox(height: 30),
          SizedBox(
            width: 200,
            child: FitHubButton(
              text: "Explore Categories",
              onPressed: () {
                setState(() => _isNotFound = false); // Quay lại list danh mục
              },
            ),
          ),
        ],
      ),
    );
  }
}
