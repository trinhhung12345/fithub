import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_button.dart';
import '../../../core/components/fit_hub_text_field.dart';
import '../view_model/login_view_model.dart';
import '../../forgot_password/view/forgot_password_screen.dart';
import 'register_screen.dart'; // Import trang đăng ký sắp tạo

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  // Biến quản lý trạng thái ẩn/hiện mật khẩu
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Text(
                  "FitHub",
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.primary,
                    fontSize: 40,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Text("Đăng nhập", style: AppTextStyles.h1),
              const SizedBox(height: 20),

              // --- Email ---
              FitHubTextField(
                key: const Key('emailField'),
                hintText: "Vui lòng nhập địa chỉ Email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              // --- Password (Updated) ---
              FitHubTextField(
                key: const Key('passwordField'),
                hintText: "Nhập mật khẩu",
                controller: _passController,
                obscureText:
                    !_isPasswordVisible, // Nếu true thì ẩn, false thì hiện
                suffixIcon: IconButton(
                  icon: Icon(
                    // Đổi icon dựa trên trạng thái
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.hintText,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),

              // ... (Phần Quên mật khẩu giữ nguyên) ...
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    // <--- Bọc GestureDetector để bắt sự kiện
                    onTap: () {
                      // Import file forgot_password_screen.dart ở trên cùng nhé
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Quên mật khẩu? ",
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: "Đặt lại mật khẩu",
                            style: AppTextStyles.link,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              FitHubButton(
                key: const Key('loginButton'),
                text: "Đăng nhập",
                isLoading: viewModel.isLoading,
                onPressed: () {
                  // --- THÊM VALIDATION ---
                  if (_emailController.text.isEmpty ||
                      _passController.text.isEmpty) {
                    // Hiện thông báo lỗi (dùng FitHubDialog hoặc SnackBar đều được)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Vui lòng nhập đầy đủ Email và Mật khẩu"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return; // Dừng lại, không gọi API
                  }
                  // -----------------------

                  viewModel.login(
                    context,
                    _emailController.text,
                    _passController.text,
                  );
                },
              ),

              const SizedBox(height: 20),

              // --- Chuyển sang trang Đăng ký ---
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Điều hướng sang trang Register
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Chưa có tài khoản? ",
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(text: "Đăng ký", style: AppTextStyles.link),
                      ],
                    ),
                  ),
                ),
              ),

              // ... (Phần Google Login giữ nguyên hoặc bỏ qua nếu muốn gọn) ...
            ],
          ),
        ),
      ),
    );
  }
}
