import '../../configs/app_assets.dart';

class Category {
  final int id;
  final String name;
  final String description;
  final bool active; // <--- THÊM TRƯỜNG NÀY

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      // Mặc định là false nếu API không trả về, để an toàn
      active: json['active'] ?? false,
    );
  }

  // --- Logic giả lập Icon (Giữ nguyên logic cũ của bạn) ---
  String get iconPath {
    switch (id) {
      case 1:
        return AppAssets.tapGym; // test -> Gym
      case 2:
        return AppAssets.phuKienTheThao; // Túi -> Phụ kiện
      case 3:
        return AppAssets.baoHo; // Cặp -> Bảo hộ
      case 4:
        return AppAssets.ngoaiTroi; // Máy tính -> Ngoài trời
      case 5:
        return AppAssets.yoga; // Giày -> Yoga
      default:
        return AppAssets.chinhTuThe;
    }
  }
}
