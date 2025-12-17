# FitHub - Fitness & E-commerce App

FitHub là ứng dụng di động được xây dựng bằng **Flutter**, kết hợp giữa thương mại điện tử (bán dụng cụ thể thao) và các tính năng hỗ trợ tập luyện (hướng dẫn bài tập, cộng đồng, quản lý lộ trình).

Dự án được thiết kế theo kiến trúc **MVVM (Model - View - ViewModel)** kết hợp với **Provider** để quản lý trạng thái, đảm bảo tính mở rộng (scalability) và dễ bảo trì (maintainability).

## 📱 Tech Stack

*   **Framework:** Flutter
*   **Language:** Dart
*   **State Management:** Provider
*   **Architecture:** MVVM
*   **Fonts:** Google Fonts (Bricolage Grotesque & Inter)
*   **Networking:** Http

## 📂 Cấu trúc dự án (Project Structure)

Dự án được tổ chức theo cấu trúc phân tách rõ ràng giữa **Giao diện (UI)**, **Logic (Business Logic)** và **Cấu hình (Configuration)**.

```text
lib/
├── configs/                 # CẤU HÌNH GIAO DIỆN & TÀI NGUYÊN
│   ├── app_assets.dart      # Quản lý đường dẫn ảnh, icon, logo (String constants)
│   ├── app_colors.dart      # Bảng màu toàn cục (Brand colors, background...)
│   ├── app_text_styles.dart # Cấu hình Typography (Font, Size, Weight)
│   └── app_theme.dart       # Theme data tổng hợp của App
│
├── core/                    # THÀNH PHẦN CỐT LÕI (DÙNG CHUNG)
│   ├── components/          # Các Widget tái sử dụng (Custom Buttons, TextFields...)
│   │   ├── fit_hub_button.dart
│   │   └── fit_hub_text_field.dart
│   └── utils/               # Các hàm tiện ích (Format date, Validate email...)
│
├── data/                    # LỚP DỮ LIỆU
│   ├── models/              # Data Models (Object mapping từ JSON)
│   └── services/            # API Services (Gọi HTTP requests)
│
├── modules/                 # CÁC TÍNH NĂNG (SCREENS) - MVVM
│   ├── auth/                # Module Xác thực (Đăng nhập/Đăng ký)
│   │   ├── view/            # UI: Chỉ chứa code giao diện (LoginScreen, RegisterScreen)
│   │   └── view_model/      # Logic: Xử lý trạng thái, gọi API (LoginViewModel...)
│   └── splash/              # Module Màn hình chờ
│       └── view/
│
└── main.dart                # ĐIỂM KHỞI CHẠY (Entry Point & Provider Setup)
```

## 📖 Giải thích chi tiết các thư mục
1. lib/configs/ (Design System)
Nơi tập trung mọi cấu hình về giao diện. Giúp đồng bộ thiết kế toàn app.
Nếu muốn đổi màu chủ đạo từ Cam sang Xanh -> Chỉ cần sửa app_colors.dart.
Nếu muốn đổi Font chữ -> Chỉ cần sửa app_text_styles.dart.
2. lib/core/ (Core Components)
Chứa các thành phần không phụ thuộc vào logic nghiệp vụ cụ thể nào ("Dumb Widgets").
Ví dụ: FitHubButton là một nút bấm có style chuẩn của App. Nó có thể được dùng ở màn hình Login, màn hình Thanh toán, hay màn hình Profile.
3. lib/modules/ (Features - MVVM)
Đây là nơi chứa code chính của các màn hình. Mỗi tính năng (Feature) sẽ là một thư mục riêng (Auth, Home, Product, Cart...). Bên trong mỗi module chia làm 2 phần:
View: Chịu trách nhiệm hiển thị UI, nhận input từ người dùng. View không xử lý logic phức tạp (như gọi API).
ViewModel: Chịu trách nhiệm giữ trạng thái (State) của màn hình (ví dụ: isLoading, errorMessage), xử lý logic và gọi xuống lớp Data.
4. lib/data/ (Data Layer)
Models: Định nghĩa cấu trúc dữ liệu (User, Product...).
Services: Nơi thực hiện các cuộc gọi API (GET, POST...). ViewModel sẽ gọi các hàm trong Service để lấy dữ liệu.