import 'package:flutter/material.dart';
import '../../../configs/app_assets.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách danh mục tĩnh mapping theo thiết kế & assets
    final List<Map<String, String>> categories = [
      {'icon': AppAssets.baoHo, 'label': 'Dụng cụ bảo hộ thể thao'},
      {'icon': AppAssets.tapGym, 'label': 'Dụng cụ tập gym tại nhà'},
      {'icon': AppAssets.yoga, 'label': 'Phụ kiện yoga'},
      {
        'icon': AppAssets.phuKienTheThao, // Icon vali/túi
        'label': 'Phụ kiện thời trang thể thao',
      },
      {
        'icon': AppAssets.tayChan, // Icon bắp tay
        'label': 'Dụng cụ tập tay, chân',
      },
      {
        'icon': AppAssets.ngoaiTroi, // Icon quả cầu
        'label': 'Phụ kiện thể thao ngoài trời',
      },
      {
        'icon': AppAssets.chinhTuThe, // Icon người chạy
        'label': 'Dụng cụ hỗ trợ chỉnh tư thế',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Center(child: FitHubBackButton()), // Nút back tròn
        // Title rỗng hoặc để trống vì design có text to bên dưới
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Tiêu đề lớn
              Text(
                "Tất cả các loại dụng cụ",
                style: AppTextStyles.h2.copyWith(fontSize: 24),
              ),

              const SizedBox(height: 30),

              // Danh sách
              Expanded(
                child: ListView.separated(
                  itemCount: categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    return _buildCategoryItem(
                      icon: item['icon']!,
                      label: item['label']!,
                      onTap: () {
                        // Sau này sẽ điều hướng sang trang ProductList với filter tương ứng
                        print("Chọn danh mục: ${item['label']}");
                        // Ví dụ:
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (_) => ProductListScreen(title: item['label']!)
                        // ));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5), // Màu xám nhạt nền
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icon bên trái
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(icon, fit: BoxFit.contain),
            ),
            const SizedBox(width: 20),

            // Text label
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500, // Semi-bold
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
