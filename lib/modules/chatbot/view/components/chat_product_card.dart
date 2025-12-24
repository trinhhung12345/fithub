import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../configs/app_colors.dart';
import '../../../../data/models/chat_model.dart';
import '../../../../data/services/product_service.dart';
import '../../../product/view/product_detail_screen.dart';

class ChatProductCard extends StatefulWidget {
  final AiProduct aiProduct;

  const ChatProductCard({super.key, required this.aiProduct});

  @override
  State<ChatProductCard> createState() => _ChatProductCardState();
}

class _ChatProductCardState extends State<ChatProductCard> {
  String? _imageUrl; // Biến lưu link ảnh sau khi lấy được
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _fetchProductImage();
  }

  // Hàm gọi API lấy ảnh
  Future<void> _fetchProductImage() async {
    try {
      // Gọi API chi tiết sản phẩm: GET /products/{id}
      final fullProduct = await _productService.getProductDetail(
        widget.aiProduct.id,
      );

      if (fullProduct != null && mounted) {
        setState(() {
          // Sử dụng getter imageUrl thông minh của Model (đã ưu tiên lấy từ files)
          _imageUrl = fullProduct.imageUrl;
        });
      }
    } catch (e) {
      print("Lỗi lấy ảnh cho chat: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return GestureDetector(
      onTap: () {
        // Chuyển sang trang chi tiết
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: widget.aiProduct.id),
          ),
        );
      },
      child: Container(
        width: 140, // Chiều rộng cố định
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- PHẦN ẢNH ---
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: _imageUrl != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          _imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image, color: Colors.grey),
                        ),
                      )
                    : const Center(
                        // Khi chưa load xong hoặc không có ảnh
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
              ),
            ),

            // --- PHẦN THÔNG TIN ---
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.aiProduct.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(widget.aiProduct.price),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
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
