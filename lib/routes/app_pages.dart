import 'package:get/get.dart';
import 'package:news/screens/news_detail_screen.dart';
import 'package:news/screens/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  // initial itu screen yg pertamakali muncul -> spalash screen 
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: _Paths.NEWS_DETAIL,
      page: () => NewsDetailScreen()
    ),
  ];
}