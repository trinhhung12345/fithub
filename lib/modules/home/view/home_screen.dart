import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports giữ nguyên
import '../../../configs/app_assets.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/home_header.dart';
import '../../../core/components/home_search_bar.dart';
import '../../../core/components/fit_hub_section_title.dart';
import '../../../core/components/product_card.dart';
import '../view_model/home_view_model.dart';
import '../../product/view/product_list_screen.dart';
import '../../product/view/product_detail_screen.dart';
import '../../cart/view/cart_screen.dart';
import '../../category/view/all_categories_screen.dart';
import '../../search/view/search_screen.dart';
import '../../category/view_model/category_view_model.dart';
import '../../profile/view_model/profile_view_model.dart';
import '../../profile/view/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().init();
      context
          .read<CategoryViewModel>()
          .fetchCategories(); // <-- Gọi API lấy danh mục
      context.read<ProfileViewModel>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final homeViewModel = context.watch<HomeViewModel>();
    // Lấy thêm ProfileViewModel để lấy thông tin user
    final profileViewModel = context.watch<ProfileViewModel>();
    final user = profileViewModel.user;
    // Lấy tối đa 5 sản phẩm đầu tiên
    final top5Products = viewModel.products.take(5).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Khi kéo reload thì load lại cả sản phẩm và thông tin user
            homeViewModel.fetchProducts();
            profileViewModel.getProfile();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header
                HomeHeader(
                  // Lấy avatar và tên từ user model
                  avatarUrl: user != null
                      ? 'https://i.pravatar.cc/150?u=${user.id}'
                      : null,

                  // Truyền tên vào đây
                  userName: user?.name,

                  onCartTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                  onAvatarTap: () {
                    // Chuyển sang Tab Profile (Tab 3)
                    // Cách đơn giản nhất là dùng DefaultTabController hoặc GlobalKey
                    // Nhưng ở đây mình để tạm print hoặc bạn có thể navigate
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // 2. Search
                HomeSearchBar(
                  readOnly: true, // Không cho nhập trực tiếp
                  onTap: () {
                    // Chuyển sang trang tìm kiếm
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 25),

                // 3. Categories (Vẫn giữ TĨNH như yêu cầu)
                FitHubSectionTitle(
                  title: "Các loại dụng cụ",
                  onSeeAll: () {
                    // Điều hướng sang trang Tất cả danh mục
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllCategoriesScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                _buildCategoriesRow(),

                const SizedBox(height: 25),

                // 4. Top 5 Newest Products (Carousel)
                FitHubSectionTitle(
                  title: "Sản phẩm gợi ý", // Đổi tên cho hợp lý
                  onSeeAll: () {
                    // --- THÊM CODE ĐIỀU HƯỚNG TẠI ĐÂY ---
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductListScreen(
                          title: "Tất cả sản phẩm", // Tiêu đề màn hình mới
                          // Không truyền keyword -> Không tìm kiếm
                          // Không truyền categoryId -> Không lọc danh mục
                          // => ViewModel sẽ tự động gọi API lấy tất cả (getProducts)
                        ),
                      ),
                    );
                    // ------------------------------------
                  },
                ),
                const SizedBox(height: 15),

                // --- PHẦN GRID VIEW ---
                if (viewModel.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (viewModel.errorMessage != null)
                  Center(child: Text(viewModel.errorMessage!))
                else if (viewModel.products.isEmpty)
                  // Nếu API chưa có dữ liệu thì hiện Mock hoặc thông báo
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("Đang cập nhật sản phẩm..."),
                    ),
                  )
                else
                  // HIỂN THỊ GRID
                  GridView.builder(
                    // Quan trọng: shrinkWrap và physics để Grid nằm gọn trong SingleChildScrollView
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    padding: EdgeInsets.zero, // Bỏ padding mặc định để căn đều
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 cột
                      childAspectRatio:
                          0.65, // Tỷ lệ chiều rộng/cao (chỉnh số này để thẻ dài/ngắn)
                      crossAxisSpacing: 16, // Khoảng cách ngang
                      mainAxisSpacing: 16, // Khoảng cách dọc
                    ),
                    // Giới hạn hiển thị 6 hoặc 8 sản phẩm thôi cho đỡ dài, hoặc bỏ .take() để hiện hết
                    itemCount: viewModel.products.length > 8
                        ? 8
                        : viewModel.products.length,
                    itemBuilder: (context, index) {
                      final product = viewModel.products[index];
                      return ProductCard(
                        imageUrl: product.imageUrl,
                        name: product.name,
                        price: product.formattedPrice,
                        tags: product.tags,
                        onTap: () {
                          // Chuyển sang chi tiết
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(productId: product.id),
                            ),
                          );
                        },
                        onFavorite: () {},
                      );
                    },
                  ),

                // Khoảng trắng dưới cùng để không bị sát đáy quá
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget Categories Tĩnh
  Widget _buildCategoriesRow() {
    // Lấy data từ ViewModel
    final categoryViewModel = context.watch<CategoryViewModel>();
    final categories = categoryViewModel.categories;

    if (categoryViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categories.isEmpty) {
      return const Text("Không có danh mục");
    }

    // Chỉ hiển thị tối đa 4 cái trên trang chủ cho đẹp
    final displayList = categories.take(4).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: displayList.map((cat) {
        return GestureDetector(
          onTap: () {
            // Bấm vào thì sang trang list sản phẩm lọc theo categoryId
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProductListScreen(title: cat.name, categoryId: cat.id),
              ),
            );
          },
          child: Column(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Image.asset(cat.iconPath, fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 70, // Giới hạn chiều rộng text để không bị tràn
                child: Text(
                  cat.name, // Tên từ API (Điện thoại, Laptop...)
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
