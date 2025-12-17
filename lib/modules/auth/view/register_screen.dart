import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_button.dart';
import '../../../core/components/fit_hub_text_field.dart';
import '../view_model/register_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  // Quản lý ẩn hiện cho 2 ô mật khẩu riêng biệt
  bool _isPassVisible = false;
  bool _isConfirmPassVisible = false;

  @override
  Widget build(BuildContext context) {
    // Lưu ý: Cần bọc RegisterViewModel ở main.dart hoặc tại đây (xem bước 5)
    final viewModel = context.watch<RegisterViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Đăng ký", style: AppTextStyles.h1),
              const SizedBox(height: 10),
              Text(
                "Tạo tài khoản để bắt đầu tập luyện cùng FitHub",
                style: AppTextStyles.body.copyWith(color: AppColors.hintText),
              ),
              const SizedBox(height: 30),

              // --- Full Name ---
              FitHubTextField(
                hintText: "Họ và tên",
                controller: _nameController,
              ),

              // --- Email ---
              FitHubTextField(
                hintText: "Địa chỉ Email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              // --- Password ---
              FitHubTextField(
                hintText: "Mật khẩu",
                controller: _passController,
                obscureText: !_isPassVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPassVisible ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.hintText,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPassVisible = !_isPassVisible;
                    });
                  },
                ),
              ),

              // --- Confirm Password ---
              FitHubTextField(
                hintText: "Nhập lại mật khẩu",
                controller: _confirmPassController,
                obscureText: !_isConfirmPassVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPassVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.hintText,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPassVisible = !_isConfirmPassVisible;
                    });
                  },
                ),
              ),

              const SizedBox(height: 30),

              FitHubButton(
                text: "Đăng ký ngay",
                isLoading: viewModel.isLoading,
                onPressed: () {
                  viewModel.register(
                    _nameController.text,
                    _emailController.text,
                    _passController.text,
                    _confirmPassController.text,
                  );
                },
              ),

              const SizedBox(height: 20),

              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context), // Quay lại login
                  child: RichText(
                    text: TextSpan(
                      text: "Đã có tài khoản? ",
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(text: "Đăng nhập", style: AppTextStyles.link),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
