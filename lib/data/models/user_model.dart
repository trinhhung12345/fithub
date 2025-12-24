class UserModel {
  final int id;
  final String code;
  final String name;
  final String email;
  final String phone;
  final String? address;
  final String? birthday; // Thêm trường này (Dạng String YYYY-MM-DD)
  final String roleName;

  UserModel({
    required this.id,
    required this.code,
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.birthday,
    required this.roleName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      code: json['code'] ?? "",
      name: json['name'] ?? "Người dùng",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      address: json['address'],
      // API trả về dạng "2000-05-20T00:00...", ta cắt lấy phần ngày thôi
      birthday: json['birthday'] != null
          ? json['birthday'].toString().split('T')[0]
          : null,
      roleName: (json['role'] != null && json['role']['roleName'] != null)
          ? json['role']['roleName']
          : "USER",
    );
  }

  bool get isAdmin => roleName == "ADMIN";
}
