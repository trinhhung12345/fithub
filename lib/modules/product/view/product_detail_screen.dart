import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../view_model/product_detail_view_model.dart';
import 'components/write_review_dialog.dart';
import '../../cart/view/cart_screen.dart';
import '../../cart/view_model/cart_view_model.dart';
import '../../../core/components/fit_hub_dialog.dart';
import 'update_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductDetailViewModel>().loadProductDetail(
        widget.productId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductDetailViewModel>();
    final product = viewModel.product;

    // 1. Chỉ hiện loading khi đang thực sự load
    if (viewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 2. Nếu load xong mà không có sản phẩm -> Hiện báo lỗi
    if (product == null) {
      return Scaffold(
        appBar: AppBar(), // Để có nút back
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 10),
              const Text("Không thể tải thông tin sản phẩm"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<ProductDetailViewModel>().loadProductDetail(
                    widget.productId,
                  );
                },
                child: const Text("Thử lại"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Nội dung cuộn
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 100,
              ), // Chừa chỗ cho nút dưới đáy
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header Ảnh ---
                  _buildImageGallery(viewModel.images),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Tên sản phẩm ---
                        Text(
                          product.name,
                          style: AppTextStyles.h2.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 10),

                        // --- Giá tiền ---
                        Text(
                          product.formattedPrice,
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.primary,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // --- Thống kê (Còn lại / Đã bán) ---
                        _buildStatsRow(product.stock, viewModel.soldCount),

                        const SizedBox(height: 20),

                        // --- Bộ chọn số lượng ---
                        _buildQuantitySelector(viewModel),

                        const SizedBox(height: 30),

                        // --- Mô tả ---
                        Text(
                          product.description,
                          style: AppTextStyles.body.copyWith(
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 20),

                        // --- Shipping & Returns (Tĩnh) ---
                        Text(
                          "Shipping & Returns",
                          style: AppTextStyles.h2.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Free standard shipping and free 60-day returns",
                          style: AppTextStyles.body.copyWith(
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // --- Reviews (Mock) ---
                        _buildReviewsSection(context, viewModel),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Nút Back & Favorite (Nổi bên trên)
            Positioned(
              top: 10,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(
                    Icons.arrow_back,
                    () => Navigator.pop(context),
                  ),
                  _buildCircleButton(Icons.favorite_border, () {}),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () {
                      if (product != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                UpdateProductScreen(product: product),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // 3. Bottom Bar (Nút Thêm vào giỏ)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    // Thêm async
                    // 1. Gọi API thêm vào giỏ
                    bool success = await context
                        .read<CartViewModel>()
                        .addToCart(product, viewModel.quantity);

                    if (success && context.mounted) {
                      // 2. Hiện thông báo
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Thêm vào giỏ thành công!"),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // 3. Chuyển trang
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Lỗi thêm vào giỏ hàng"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          // Tính tổng tiền tạm tính
                          "${(product.price * viewModel.quantity).toStringAsFixed(0)} VND", // Format sơ sài, dùng hàm format chuẩn sau
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          "Thêm vào giỏ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS CON ---

  Widget _buildImageGallery(List<String> images) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.network(images[index], fit: BoxFit.cover);
        },
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  Widget _buildStatsRow(int stock, int sold) {
    return Column(
      children: [
        _buildStatItem("Còn lại", stock.toString()),
        const SizedBox(height: 10),
        _buildStatItem("Đã bán", sold.toString()),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body.copyWith(fontSize: 16)),
          Text(value, style: AppTextStyles.h2.copyWith(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(ProductDetailViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Số lượng", style: TextStyle(fontSize: 16)),
          Row(
            children: [
              _buildQtyBtn(Icons.remove, () => viewModel.decreaseQuantity()),
              SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    "${viewModel.quantity}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _buildQtyBtn(Icons.add, () => viewModel.increaseQuantity()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: AppColors.secondary, // Màu cam nhạt/nâu giống design
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildReviewsSection(
    BuildContext context,
    ProductDetailViewModel viewModel,
  ) {
    // Lưu ý: Truyền viewModel vào để gọi hàm addReview
    final reviews = viewModel.reviews;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Tiêu đề + Nút Viết đánh giá
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Đánh giá (${reviews.length})",
              style: AppTextStyles.h2.copyWith(fontSize: 18),
            ),

            // Nút Viết Đánh Giá Mới
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => WriteReviewDialog(
                    onSubmit: (rating, content) async {
                      // 1. Thử Gửi đánh giá mới (Add)
                      final errorAdd = await context
                          .read<ProductDetailViewModel>()
                          .addReview(rating, content);

                      if (!context.mounted) return;

                      if (errorAdd == null) {
                        // -> Thành công ngay lần đầu
                        FitHubDialog.show(
                          context,
                          title: "Thành công",
                          content: "Cảm ơn đánh giá của bạn!",
                          buttonText: "Đóng",
                        );
                      } else {
                        // 2. Nếu lỗi (nghi ngờ là đã đánh giá rồi), hỏi người dùng có muốn Cập nhật không?
                        // (Bạn có thể check chuỗi errorAdd chứa chữ "already reviewed" để chắc chắn hơn)

                        FitHubDialog.show(
                          context,
                          title: "Đã có đánh giá",
                          content:
                              "Bạn đã đánh giá sản phẩm này rồi. Bạn có muốn cập nhật lại nội dung không?",
                          isSuccess: false, // Icon chấm than
                          buttonText: "Cập nhật ngay",
                          onPressed: () async {
                            // --- GỌI HÀM CẬP NHẬT (UPDATE) ---
                            final errorUpdate = await context
                                .read<ProductDetailViewModel>()
                                .editMyReview(rating, content);

                            if (context.mounted) {
                              if (errorUpdate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Cập nhật thành công!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(errorUpdate),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        );
                      }
                    },
                  ),
                );
              },
              icon: const Icon(Icons.edit, size: 16, color: AppColors.primary),
              label: Text("Viết đánh giá", style: AppTextStyles.link),
            ),
          ],
        ),

        const SizedBox(height: 5),
        const Text(
          "4.5 sao trung bình",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        // List Reviews
        if (reviews.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Chưa có đánh giá nào. Hãy là người đầu tiên!",
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ...reviews.map(
            (review) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(review['avatar']),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              review['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  index < review['rating']
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          review['content'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          review['date'],
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
