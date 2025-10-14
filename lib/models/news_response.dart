import 'package:news/models/news_articles.dart';

class NewsResponse {
  final String status;
  final int totalResults;
  final List<NewsArticles> articles;

 NewsResponse({required this.status, required this.totalResults, required this.articles});  
  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      status: json['status'] ?? '',
      totalResults: json['totalResults'] ?? 0,
      // kode yang digunakan untuk mengkonversi dat amentah dari serve agar
      // siap d gunakan untuk aplikasi
      articles: (json['articles'] as List<dynamic>?)
              ?.map((article) => NewsArticles.fromJson(article))
              .toList() ??  
          [],
    );
  }

 
}