import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart';
import '../../../core/components/fit_hub_button.dart';
import '../../../core/components/fit_hub_text_field.dart';
import '../../../core/components/fit_hub_dialog.dart'; // Import Dialog
import '../view_model/forgot_password_view_model.dart'; // Import ViewModel

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Lắng nghe ViewModel
    final viewModel = context.watch<ForgotPasswordViewModel>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FitHubBackButton(),
              const SizedBox(height: 30),

              Text("Quên mật khẩu", style: AppTextStyles.h1),
              const SizedBox(height: 10),
              const Text(
                "Nhập email của bạn, chúng tôi sẽ gửi mật khẩu mới đến hộp thư.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),

              FitHubTextField(
                hintText: "Nhập địa chỉ email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 30),

              FitHubButton(
                text: "Gửi yêu cầu",
                isLoading: viewModel.isLoading,
                onPressed: () async {
                  final email = _emailController.text.trim();

                  if (email.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Vui lòng nhập Email")),
                    );
                    return;
                  }

                  // Gọi ViewModel
                  final success = await viewModel.submitRequest(email);

                  if (!context.mounted) return;

                  if (success) {
                    // --- THÀNH CÔNG ---
                    FitHubDialog.show(
                      context,
                      title: "Đã gửi Email",
                      content:
                          "Mật khẩu mới đã được gửi đến $email.\nVui lòng kiểm tra hòm thư (cả mục Spam).",
                      buttonText: "Về trang Đăng nhập",
                      onPressed: () {
                        // Quay về màn hình Login (xóa hết các màn hình trước đó)
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                    );
                  } else {
                    // --- THẤT BẠI ---
                    FitHubDialog.show(
                      context,
                      title: "Gửi thất bại",
                      content: "Email không tồn tại hoặc có lỗi hệ thống.",
                      isSuccess: false,
                      buttonText: "Thử lại",
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
