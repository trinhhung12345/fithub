import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../core/components/fit_hub_back_button.dart'; // Nút back tròn
import '../../../core/components/product_card.dart'; // Thẻ sản phẩm
import '../../../core/components/filters/filter_chip_item.dart'; // Component mới
import '../../../core/components/filters/sort_bottom_sheet.dart'; // Component mới
import '../../../core/components/filters/price_filter_bottom_sheet.dart'; // Component mới
import '../view_model/product_list_view_model.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String title;
  final String? keyword;
  final int? categoryId;

  const ProductListScreen({
    super.key,
    required this.title,
    this.keyword,
    this.categoryId,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Các biến lọc
  String _currentSort = "Recommended";

  @override
  void initState() {
    super.initState();
    // Load dữ liệu khi vào màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductListViewModel>().loadData(
        keyword: widget.keyword,
        categoryId: widget.categoryId,
      );
    });
  }

  // Hàm hiện Sort Modal
  void _showSort() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SortBottomSheet(
        currentSort: _currentSort,
        onApply: (val) {
          setState(() => _currentSort = val);
          // Gọi ViewModel sort lại
          context.read<ProductListViewModel>().sortProducts(val);
        },
      ),
    );
  }

  // Hàm hiện Price Modal
  void _showPrice() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Để đẩy lên khi hiện phím
      backgroundColor: Colors.transparent,
      builder: (_) => PriceFilterBottomSheet(
        onApply: (min, max) {
          print("Lọc giá từ $min đến $max");
          // Gọi ViewModel lọc giá
          context.read<ProductListViewModel>().filterPrice(min, max);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductListViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 1. Header (Back + SearchBar hiển thị keyword hiện tại)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const FitHubBackButton(),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(
                        context,
                      ), // Bấm vào thì quay lại trang search
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Filter Bar (Các nút lọc)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Nút Sort
                  FilterChipItem(
                    label: "Sort by",
                    onTap: _showSort,
                    isSelected: false,
                    showDropdownIcon: true,
                  ),
                  // Nút On Sale
                  FilterChipItem(
                    label: "On Sale",
                    onTap: () {},
                    isSelected: true, // Ví dụ đang chọn
                    showDropdownIcon: false,
                  ),
                  // Nút Price
                  FilterChipItem(
                    label: "Price",
                    onTap: _showPrice,
                    isSelected: false,
                    showDropdownIcon: true,
                  ),
                  // Nút Gender (Mock)
                  FilterChipItem(
                    label: "Men",
                    onTap: () {},
                    isSelected: true,
                    showDropdownIcon: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            const Divider(height: 1),

            // 3. Kết quả tìm kiếm
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${viewModel.products.length} Results Found",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            // 4. GridView sản phẩm
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.products.isEmpty
                  ? const Center(child: Text("Chưa có sản phẩm nào"))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 cột
                            childAspectRatio: 0.62,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 24,
                          ),
                      itemCount: viewModel.products.length,
                      itemBuilder: (context, index) {
                        final product = viewModel.products[index];
                        return ProductCard(
                          imageUrl: product.imageUrl,
                          name: product.name,
                          price: product.formattedPrice,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(productId: product.id),
                              ),
                            );
                          },
                          onFavorite: () {
                            print("Thả tim ID: ${product.id}");
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
