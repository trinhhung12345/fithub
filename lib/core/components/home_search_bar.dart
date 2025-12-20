import 'package:flutter/material.dart';
import '../../configs/app_assets.dart';
import '../../configs/app_colors.dart';
import '../../configs/app_text_styles.dart';

class HomeSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool
  readOnly; // Nếu true: Bấm vào sẽ không hiện phím mà chuyển trang (nếu muốn)

  const HomeSearchBar({
    super.key,
    this.hintText = "Tìm kiếm sản phẩm : Đai lưng, ...",
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3), // Màu xám nhạt nền search
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          enabled:
              !readOnly, // Nếu readOnly = true thì chặn nhập liệu trực tiếp
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.body.copyWith(color: AppColors.hintText),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              // Đảm bảo bạn đã khai báo icon này trong AppAssets
              child: Image.asset(AppAssets.search, width: 20, height: 20),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
