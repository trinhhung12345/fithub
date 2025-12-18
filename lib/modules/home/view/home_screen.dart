import 'package:flutter/material.dart';
import '../../../configs/app_assets.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Avatar + Cart)
              _buildHeader(),

              const SizedBox(height: 20),

              // 2. Search Bar
              _buildSearchBar(),

              const SizedBox(height: 25),

              // 3. Categories Section
              _buildSectionTitle("Các loại dụng cụ", onSeeAll: () {}),
              const SizedBox(height: 15),
              _buildCategoriesRow(),

              const SizedBox(height: 25),

              // 4. Best Sellers Section
              _buildSectionTitle("Mặt hàng bán chạy", onSeeAll: () {}),
              const SizedBox(height: 15),
              _buildProductGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets con ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar (Giả lập)
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(
            'https://i.pravatar.cc/150?img=11',
          ), // Ảnh mạng demo
          backgroundColor: Colors.grey,
        ),
        // Nút Giỏ hàng
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.primary, // Màu cam
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3), // Màu xám nhạt
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Tìm kiếm sản phẩm : Đai lưng, ...",
          hintStyle: AppTextStyles.body.copyWith(color: AppColors.hintText),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(AppAssets.search, width: 20, height: 20),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.h2.copyWith(fontSize: 18)),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            "Xem tất cả",
            style: AppTextStyles.body.copyWith(color: AppColors.secondary),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesRow() {
    // Danh sách danh mục tĩnh (sau này lấy từ API)
    final categories = [
      {'icon': AppAssets.baoHo, 'label': 'Dụng cụ\nbảo hộ'},
      {'icon': AppAssets.tapGym, 'label': 'Dụng cụ\ntập gym'},
      {'icon': AppAssets.yoga, 'label': 'Phụ kiện\nyoga'},
      {'icon': AppAssets.tayChan, 'label': 'Dụng cụ\ntay/chân'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.map((cat) {
        return _CategoryItem(iconPath: cat['icon']!, label: cat['label']!);
      }).toList(),
    );
  }

  Widget _buildProductGrid() {
    // Dữ liệu sản phẩm giả lập
    final products = [
      {
        'image':
            'https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/9769966c-54a4-4bf8-b543-96b66e30b057/m-j-ess-flc-short-x-ma-bQWvj1.png',
        'name': 'Mohair Blouse',
        'price': '\$24.55',
        'oldPrice': '\$54.55',
      },
      {
        'image':
            'https://static.nike.com/a/images/c_limit,w_592,f_auto/t_product_v1/9769966c-54a4-4bf8-b543-96b66e30b057/m-j-ess-flc-short-x-ma-bQWvj1.png',
        'name': 'Gym Short',
        'price': '\$24.55',
        'oldPrice': '\$54.55',
      },
    ];

    return GridView.builder(
      shrinkWrap: true, // Quan trọng để nằm trong ScrollView
      physics: const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của Grid
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 cột
        childAspectRatio: 0.65, // Tỷ lệ chiều rộng/cao của thẻ
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final item = products[index];
        return _ProductCard(
          imageUrl: item['image']!,
          name: item['name']!,
          price: item['price']!,
          oldPrice: item['oldPrice']!,
        );
      },
    );
  }
}

// --- Component: Category Item ---
class _CategoryItem extends StatelessWidget {
  final String iconPath;
  final String label;

  const _CategoryItem({required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon không có vòng tròn, chỉ là ảnh png
        SizedBox(
          width: 50,
          height: 50,
          child: Image.asset(iconPath, fit: BoxFit.contain),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}

// --- Component: Product Card ---
class _ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String oldPrice;

  const _ProductCard({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.oldPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9), // Nền xám rất nhạt cho thẻ
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh + Icon tim
          Expanded(
            child: Stack(
              children: [
                // Ảnh sản phẩm
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                    ), // Dùng ảnh mạng demo
                  ),
                ),
                // Icon trái tim
                Positioned(
                  top: 8,
                  right: 8,
                  child: const Icon(Icons.favorite_border, size: 20),
                ),
              ],
            ),
          ),

          // Thông tin
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      price,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      oldPrice,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.secondary,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
