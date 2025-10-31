import 'package:get/get.dart';
import 'package:news/models/news_articles.dart';

class FavoriteController extends GetxController {
  var favoriteList = <NewsArticles>[].obs;

  void toggleFavorite(NewsArticles article) {
    if (isFavorite(article)) {
      favoriteList.removeWhere((a) => a.url == article.url);
    } else {
      favoriteList.add(article);
    }
  }

  bool isFavorite(NewsArticles article) {
    return favoriteList.any((a) => a.url == article.url);
  }
}
