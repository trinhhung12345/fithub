import '../../configs/app_assets.dart';

class Category {
  final int id;
  final String name;
  final String description;

  Category({required this.id, required this.name, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      description: json['description'] ?? "",
    );
  }

  // --- Logic giả lập Icon (Vì API không trả về ảnh) ---
  String get iconPath {
    // Map tạm ID từ API sang Icon thể thao có sẵn
    switch (id) {
      case 1:
        return AppAssets.tapGym; // Điện thoại -> Gym
      case 2:
        return AppAssets.phuKienTheThao; // Phụ kiện -> Phụ kiện
      case 3:
        return AppAssets.baoHo; // Laptop -> Bảo hộ
      case 4:
        return AppAssets.ngoaiTroi; // Thiết bị thông minh -> Ngoài trời
      case 5:
        return AppAssets.yoga; // Âm thanh -> Yoga
      default:
        return AppAssets.chinhTuThe; // Mặc định
    }
  }
}
