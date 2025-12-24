import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để format ngày
import 'package:provider/provider.dart';
import '../../../configs/app_colors.dart';
import '../../../configs/app_text_styles.dart';
import '../../../core/components/fit_hub_back_button.dart';
import '../../../core/components/fit_hub_button.dart';
import '../../../core/components/fit_hub_text_field.dart'; // Tận dụng component cũ
import '../view_model/profile_view_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController(); // Date of Birth

  @override
  void initState() {
    super.initState();
    // Lấy dữ liệu user hiện tại điền vào form
    final user = context.read<ProfileViewModel>().user;
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone;
      _addressController.text = user.address ?? "";
      _dobController.text = user.birthday ?? "";
    }
  }

  // Hàm chọn ngày sinh
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    // Nếu đã có ngày sinh cũ thì focus vào ngày đó
    if (_dobController.text.isNotEmpty) {
      try {
        initialDate = DateFormat("yyyy-MM-dd").parse(_dobController.text);
      } catch (_) {}
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // Custom màu cho DatePicker giống App
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Format thành YYYY-MM-DD để gửi lên API
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

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
          "Chỉnh sửa thông tin",
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
              "Họ và tên",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            FitHubTextField(
              hintText: "Nhập họ tên",
              controller: _nameController,
            ),

            const SizedBox(height: 15),
            const Text(
              "Số điện thoại",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            FitHubTextField(
              hintText: "Nhập số điện thoại",
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 15),
            const Text(
              "Địa chỉ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            FitHubTextField(
              hintText: "Nhập địa chỉ",
              controller: _addressController,
            ),

            const SizedBox(height: 15),
            const Text(
              "Ngày sinh",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Ô chọn ngày sinh (Readonly, bấm vào hiện lịch)
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: FitHubTextField(
                  hintText: "YYYY-MM-DD",
                  controller: _dobController,
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            FitHubButton(
              text: "Lưu thay đổi",
              isLoading: viewModel.isLoading,
              onPressed: () async {
                // Gọi ViewModel
                bool success = await viewModel.updateUserInfo(
                  name: _nameController.text,
                  phone: _phoneController.text,
                  address: _addressController.text,
                  birthday: _dobController.text,
                );

                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Cập nhật thành công!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context); // Quay về trang Profile
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Cập nhật thất bại"),
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
