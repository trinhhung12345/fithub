import 'package:flutter/material.dart';
import '../../../configs/app_assets.dart';
import '../../../configs/app_text_styles.dart';

// Import toàn bộ components
import '../../../core/components/home_header.dart';
import '../../../core/components/home_search_bar.dart';
import '../../../core/components/fit_hub_section_title.dart';
import '../../../core/components/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
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
        'price': '\$30.00',
        'oldPrice': null,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Mới)
              HomeHeader(
                avatarUrl: 'https://i.pravatar.cc/150?img=11', // Demo ảnh
                onCartTap: () {
                  print("Vào giỏ hàng");
                },
                onAvatarTap: () {
                  print("Vào profile");
                },
              ),

              const SizedBox(height: 20),

              // 2. Search Bar
              HomeSearchBar(onTap: () => print("Search...")),

              const SizedBox(height: 25),

              // 3. Categories
              FitHubSectionTitle(
                // Title (Mới)
                title: "Các loại dụng cụ",
                onSeeAll: () => print("Xem tất cả loại"),
              ),
              const SizedBox(height: 15),
              _buildCategoriesRow(), // Cái này giữ nguyên vì logic map icon đơn giản

              const SizedBox(height: 25),

              // 4. Best Sellers
              FitHubSectionTitle(
                // Title (Mới)
                title: "Mặt hàng bán chạy",
                onSeeAll: () => print("Xem tất cả sp"),
              ),
              const SizedBox(height: 15),

              // Gridview
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final item = products[index];
                  return ProductCard(
                    imageUrl: item['image']!,
                    name: item['name']!,
                    price: item['price']!,
                    oldPrice: item['oldPrice'],
                    onTap: () {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget con này nhỏ và đặc thù của Home nên để đây cũng được, hoặc tách nốt tùy bạn
  Widget _buildCategoriesRow() {
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
        return Column(
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(cat['icon']!, fit: BoxFit.contain),
            ),
            const SizedBox(height: 8),
            Text(
              cat['label']!,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(fontSize: 12),
            ),
          ],
        );
      }).toList(),
    );
  }
}
