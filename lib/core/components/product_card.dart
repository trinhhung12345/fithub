import 'package:flutter/material.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_text_styles.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final String? oldPrice; // Có thể null nếu không giảm giá
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.oldPrice,
    this.onTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9), // Nền xám rất nhạt
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Ảnh + Nút Tim
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
                        // Xử lý khi lỗi ảnh (optional)
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  ),
                  // Icon trái tim
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, size: 22),
                      color: AppColors.black,
                      onPressed: onFavorite,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Thông tin text
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
                    overflow: TextOverflow.ellipsis, // Cắt bớt nếu tên dài
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
                      // Chỉ hiện giá cũ nếu có
                      if (oldPrice != null)
                        Text(
                          oldPrice!,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.secondary, // Màu cam nhạt/nâu
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
      ),
    );
  }
}
