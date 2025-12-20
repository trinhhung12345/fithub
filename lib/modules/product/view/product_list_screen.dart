import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart'; // Nút back tròn
import '../../../core/components/product_card.dart'; // Thẻ sản phẩm
import '../view_model/product_list_view_model.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String title;

  const ProductListScreen({
    super.key,
    required this.title, // Truyền tên danh mục vào đây
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    // Load dữ liệu khi vào màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductListViewModel>().getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductListViewModel>();
    final products = viewModel.products;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // 1. Nút Back (Component cũ)
              const FitHubBackButton(),

              const SizedBox(height: 20),

              // 2. Tiêu đề + Số lượng (Giống thiết kế)
              // Ví dụ: Dụng cụ bảo hộ thể thao (34)
              RichText(
                text: TextSpan(
                  text: widget.title,
                  style: AppTextStyles.h2.copyWith(fontSize: 22),
                  children: [
                    TextSpan(
                      text: " (${products.length})", // Hiển thị số lượng
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 22,
                        color: AppColors.hintText, // Màu xám cho số lượng
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. Lưới sản phẩm (GridView)
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : products.isEmpty
                    ? const Center(child: Text("Chưa có sản phẩm nào"))
                    : GridView.builder(
                        // padding bottom để không bị sát đáy quá
                        padding: const EdgeInsets.only(bottom: 20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 cột
                              childAspectRatio:
                                  0.62, // Tỉ lệ khung hình (cao hơn chút để chứa đủ thông tin)
                              crossAxisSpacing: 16, // Khoảng cách ngang
                              mainAxisSpacing: 24, // Khoảng cách dọc
                            ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            imageUrl: product.imageUrl,
                            name: product.name,
                            price: product.formattedPrice,
                            // oldPrice: ... (nếu có)
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    productId: product.id,
                                  ),
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
      ),
    );
  }
}
