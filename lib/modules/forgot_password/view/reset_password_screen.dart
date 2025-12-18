import 'package:flutter/material.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart';
import '../../../core/components/fit_hub_button.dart';
import '../../../core/components/fit_hub_text_field.dart';
import '../../auth/view/login_screen.dart';
import '../../auth/view/success_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passController = TextEditingController();
  bool _isPassVisible = false;

  @override
  Widget build(BuildContext context) {
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

              Text("Nhập mật khẩu mới", style: AppTextStyles.h1),
              const SizedBox(height: 30),

              FitHubTextField(
                hintText: "Nhập mật khẩu mới",
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

              const SizedBox(height: 30),

              FitHubButton(
                text: "Tiếp tục",
                onPressed: () {
                  // Chuyển sang màn hình thông báo Thành công
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SuccessScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
