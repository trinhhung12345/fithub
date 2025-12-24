import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../data/local/app_preferences.dart';
import '../../auth/view/login_screen.dart';
import '../../product/view/add_product_screen.dart';
import '../view_model/profile_view_model.dart'; // Import ViewModel
import 'edit_profile_screen.dart'; // Import
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi API lấy thông tin ngay khi vào màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe dữ liệu
    final viewModel = context.watch<ProfileViewModel>();
    final user = viewModel.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Cá nhân", style: AppTextStyles.h2),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 1. Header Profile (Dữ liệu thật)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          // Avatar giả lập theo ID (vì API chưa có ảnh)
                          backgroundImage: NetworkImage(
                            user != null
                                ? 'https://i.pravatar.cc/150?u=${user.id}'
                                : 'https://i.pravatar.cc/150',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tên thật
                            Text(
                              user?.name ?? "Khách",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Email thật
                            Text(
                              user?.email ?? "Chưa đăng nhập",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            if (user?.phone != null)
                              Text(
                                user!.phone,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Menu Options
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          icon: Icons.person_outline,
                          text: "Chỉnh sửa thông tin",
                          onTap: () {
                            // Chuyển sang màn hình Edit
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        _buildMenuItem(
                          icon: Icons.map_outlined,
                          text:
                              "Sổ địa chỉ", // Có thể hiển thị user?.address ở đây
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildMenuItem(
                          icon: Icons.lock_outline,
                          text: "Đổi mật khẩu",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. ADMIN AREA (Chỉ hiện nếu role là ADMIN)
                  if (user != null && user.isAdmin) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8, bottom: 8),
                        child: Text(
                          "Khu vực Admin",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildMenuItem(
                            icon: Icons.add_box_outlined,
                            text: "Quản lý sản phẩm",
                            iconColor: AppColors.primary,
                            textColor: AppColors.primary,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddProductScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // 4. Logout
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _buildMenuItem(
                      icon: Icons.logout,
                      text: "Đăng xuất",
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      onTap: () async {
                        await AppPreferences.removeToken();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color iconColor = Colors.black54,
    Color textColor = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
