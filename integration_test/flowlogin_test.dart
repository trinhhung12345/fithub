import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <--- 1. Thêm Import này
import 'package:fithub/main.dart' as app;
import 'package:fithub/modules/main/main_screen.dart';
import 'package:fithub/modules/auth/view/login_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Kiểm thử luồng Đăng nhập (Login Flow)', () {
    // --- 2. CHẠY HÀM NÀY TRƯỚC MỖI TEST CASE ---
    setUp(() async {
      // Lấy instance của SharedPreferences thật trên máy
      final prefs = await SharedPreferences.getInstance();
      // Xóa sạch mọi dữ liệu (Token, UserInfo...)
      await prefs.clear();
      print("🧹 Đã dọn dẹp Token cũ!");
    });

    // --- TC_01: Đăng nhập thành công ---
    testWidgets('TC_01: Đăng nhập thành công với tài khoản hợp lệ', (
      tester,
    ) async {
      await _startApp(tester);
      await _performLogin(tester, 'wearingarmor12345@gmail.com', 'hung12345');
      await _verifyLoginSuccess(tester);
    });

    // --- TC_02: Validate rỗng ---
    testWidgets('TC_02: Báo lỗi khi bỏ trống thông tin', (tester) async {
      await _startApp(tester);
      await _tapLoginButton(tester);
      await _verifyErrorMessage(
        tester,
        "Vui lòng nhập đầy đủ Email và Mật khẩu",
      );
      await _verifyStillAtLoginScreen(tester);
    });

    // --- TC_03: Sai mật khẩu ---
    testWidgets('TC_04: Báo lỗi khi nhập sai mật khẩu', (tester) async {
      await _startApp(tester);
      // Nhập sai pass
      await _performLogin(
        tester,
        'wearingarmor12345@gmail.com',
        'sai_pass_roi',
      );

      // Chờ API (Nếu mạng chậm có thể tăng duration lên)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Kiểm tra vẫn ở Login (chưa vào trong)
      await _verifyStillAtLoginScreen(tester);
    });
  });
}

// CÁC HÀM HỖ TRỢ (GIỮ NGUYÊN NHƯ CŨ)

Future<void> _startApp(WidgetTester tester) async {
  // Quan trọng: Đảm bảo app khởi động lại hoàn toàn UI từ đầu
  app.main();
  await tester.pumpAndSettle();
}

Future<void> _performLogin(
  WidgetTester tester,
  String email,
  String password,
) async {
  final emailField = find.byKey(const Key('emailField'));
  final passwordField = find.byKey(const Key('passwordField'));

  await tester.enterText(emailField, email);
  await tester.pumpAndSettle(const Duration(milliseconds: 50));

  await tester.enterText(passwordField, password);
  await tester.pumpAndSettle(const Duration(milliseconds: 50));

  await _tapLoginButton(tester);
}

Future<void> _tapLoginButton(WidgetTester tester) async {
  final loginButton = find.byKey(const Key('loginButton'));
  await tester.tap(loginButton);
  await tester.pumpAndSettle();
}

Future<void> _verifyLoginSuccess(WidgetTester tester) async {
  expect(find.byType(MainScreen), findsOneWidget);
  expect(find.byType(LoginScreen), findsNothing);
}

Future<void> _verifyStillAtLoginScreen(WidgetTester tester) async {
  expect(find.byType(LoginScreen), findsOneWidget);
  expect(find.byType(MainScreen), findsNothing);
}

Future<void> _verifyErrorMessage(WidgetTester tester, String message) async {
  expect(find.text(message), findsOneWidget);
}