import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news/controllers/favorite_controller.dart';
import 'package:news/utils/app_colors.dart';
import 'package:news/widgets/news_card.dart';
import 'package:news/routes/app_pages.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoriteController favoriteController = Get.find<FavoriteController>();

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bidong,
      appBar: AppBar(
        backgroundColor: AppColors.bidong,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your Favorites',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.divider,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 6),
          ],
        ),
      ),
      body: Obx(() {
        if (favoriteController.favoriteList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  'No favorites yet ',
                  style: TextStyle(fontSize: 18, color: AppColors.divider),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: favoriteController.favoriteList.length,
          itemBuilder: (context, index) {
            final article = favoriteController.favoriteList[index];
            return NewsCard(
              article: article,
              onTap: () => Get.toNamed(Routes.NEWS_DETAIL, arguments: article),
            );
          },
        );
      }),
    );
  }
}
