import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fithub/main.dart' as app; // Import file main của app
import 'package:fithub/modules/main/main_screen.dart'; // Import màn hình đích đến (Home/Main)

void main() {
  // 1. Khởi tạo binding cho Integration Test
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test luồng đăng nhập thành công với tài khoản thật', (
    WidgetTester tester,
  ) async {
    // 2. Khởi chạy ứng dụng
    app.main();

    // Đợi app render xong frame đầu tiên và hết các animation (Splash screen...)
    // Splash screen của bạn delay 3 giây, nên ta pumpAndSettle sẽ đợi nó xong.
    await tester.pumpAndSettle();

    // --- BẮT ĐẦU TEST ---

    // 3. Tìm các widget bằng Key
    final emailField = find.byKey(const Key('emailField'));
    final passwordField = find.byKey(const Key('passwordField'));
    final loginButton = find.byKey(const Key('loginButton'));

    // Kiểm tra xem các widget có xuất hiện trên màn hình không
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    // 4. Nhập liệu (Acc hợp lệ của bạn)
    await tester.enterText(emailField, 'wearingarmor12345@gmail.com');
    await tester.pumpAndSettle(
      const Duration(milliseconds: 50),
    ); // Delay nhỏ để ổn định UI

    await tester.enterText(passwordField, 'hung12345');
    await tester.pumpAndSettle(const Duration(milliseconds: 50));

    // 5. Bấm nút Đăng nhập
    await tester.tap(loginButton);

    // 6. Chờ API phản hồi và chuyển trang
    // Vì gọi API thật qua mạng nên có thể lâu, ta dùng pumpAndSettle
    // Nếu mạng quá lag, có thể cần await Future.delayed(const Duration(seconds: 5));
    print("Đang gọi API Login...");
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // 7. Kiểm chứng kết quả (Verify)
    // Sau khi login thành công, App sẽ chuyển sang MainScreen.
    // Ta kiểm tra xem MainScreen có hiện ra không.
    expect(find.byType(MainScreen), findsOneWidget);

    // Hoặc kiểm tra xem có hiện icon Home ở bottom bar không (chắc chắn hơn)
    expect(find.byIcon(Icons.home), findsOneWidget);

    print("✅ Test Đăng nhập thành công!");
  });
}
