import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:news/bindings/app_bindings.dart';
import 'package:news/routes/app_pages.dart';
import 'package:news/utils/app_colors.dart';

void main() async {
  //pemanggilan data namanya async
  WidgetsFlutterBinding.ensureInitialized();

  //load environtment variables first before running the app
  await dotenv.load(
    fileName: '.env',
  ); // untuk menstrukkan file env agar mudah di kelola, maknaya di simpen di .env
  runApp(News());
}

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    // material app class yang di panggil sama widget, karna material app itu kayu penyangganya
    return GetMaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.bidong,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bidong,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
    );
  }
}
