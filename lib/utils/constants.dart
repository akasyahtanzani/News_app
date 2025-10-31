import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String baseUrl= 'https://newsapi.org/v2/';

  // Get PI key from env variables 
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  // List of endpoints
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';

  // List of categories
  static const List<String> categories = [
    'general',
    'technology',
    'business',
    'healt',
    'science',
    'entertainment',
  ];

  // countries
static const String defaultCountry = 'us';

// app info
static const String appName = 'New App';
static const String appVersion = '1.0.0';
}