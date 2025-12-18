class AuthResponse {
  final int code;
  final AuthData? data;
  final String? message;

  AuthResponse({required this.code, this.data, this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      code: json['code'] ?? 0,
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class AuthData {
  final int? id; // Dùng cho cả codeId lúc gửi OTP và userId lúc login
  final String? email;
  final String? name;
  final String? phone;
  final String? accessToken;

  AuthData({this.id, this.email, this.name, this.phone, this.accessToken});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      accessToken: json['accessToken'],
    );
  }
}
