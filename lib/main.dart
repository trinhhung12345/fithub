import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modules/auth/view_model/login_view_model.dart';
import 'modules/auth/view_model/register_view_model.dart'; // Import mới
import 'modules/splash/view/splash_screen.dart';
import 'configs/app_colors.dart';
import 'modules/home/view_model/home_view_model.dart';
import 'modules/product/view_model/product_list_view_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(
          create: (_) => RegisterViewModel(),
        ), // Thêm dòng này
        ChangeNotifierProvider(create: (_) => HomeViewModel()), // Thêm dòng này
        ChangeNotifierProvider(
          create: (_) => ProductListViewModel(),
        ), // Thêm dòng này
      ],
      child: MaterialApp(
        title: 'FitHub',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
