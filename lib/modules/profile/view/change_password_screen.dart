import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart';
import '../../../core/components/fit_hub_button.dart';
import '../../../core/components/fit_hub_text_field.dart';
import '../view_model/profile_view_model.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  // Biến quản lý ẩn hiện mật khẩu (3 ô riêng biệt)
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Center(child: FitHubBackButton()),
        title: Text(
          "Đổi mật khẩu",
          style: AppTextStyles.h2.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mật khẩu hiện tại",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            FitHubTextField(
              hintText: "Nhập mật khẩu cũ",
              controller: _oldPassController,
              obscureText: _obscureOld,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureOld ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _obscureOld = !_obscureOld),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Mật khẩu mới",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            FitHubTextField(
              hintText: "Nhập mật khẩu mới",
              controller: _newPassController,
              obscureText: _obscureNew,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNew ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Xác nhận mật khẩu mới",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            FitHubTextField(
              hintText: "Nhập lại mật khẩu mới",
              controller: _confirmPassController,
              obscureText: _obscureConfirm,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),
            ),

            const SizedBox(height: 40),

            FitHubButton(
              text: "Lưu mật khẩu",
              isLoading: viewModel.isLoading,
              onPressed: () async {
                // Gọi ViewModel
                final errorMessage = await viewModel.changePassword(
                  oldPass: _oldPassController.text,
                  newPass: _newPassController.text,
                  confirmPass: _confirmPassController.text,
                );

                if (!context.mounted) return;

                if (errorMessage == null) {
                  // Thành công
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Đổi mật khẩu thành công!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context); // Quay về
                } else {
                  // Thất bại
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
