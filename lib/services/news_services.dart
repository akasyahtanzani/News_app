import 'dart:convert';

import 'package:news/models/news_response.dart';
import 'package:news/utils/constants.dart';
import 'package:http/http.dart' as http;
// mendefinisikan sebuah package/library menjadi sebuah variable GET

class NewsServices {
  static const String _baseUrl = Constants.baseUrl;
  static final String _apiKey = Constants.apiKey;

// fungsi yang bertujuan untuk membuat request get ke serve
  Future<NewsResponse> getTopHeadLines({
    String country = Constants.defaultCountry,
    String? category,
    int page = 1,
    int pageSize = 20
  }) async {
    try { 
      final Map<String, String>queryParams = {
        'apiKey':_apiKey,
        'country':country,
        'page':page.toString(),
        'pageSize':pageSize.toString()
      };

     // statement yang dijalankan ketika category tidak kosong
      if (category !=null && category.isNotEmpty) {
        queryParams['category']= category;
      }

    // berfungsi untuk parsing data dari json ke UI
    // simplenya: kita daftarin baseURL + endpoint yang akan di gunakan 
      final uri=Uri.parse('$_baseUrl${Constants.topHeadlines  }')
            .replace(queryParameters: queryParams);
            
        // untuk menyinpam respon yang di berikan oleh serve
        final response = await http.get(uri);  

        // code yang akan jalanakan jika request berhasil ke API sukses 
        if (response.statusCode == 200) {
          // untuk merubah data dari json ke bahasa dart 
          final jsonData = json.decode(response.body);
          return NewsResponse.fromJson(jsonData);
          // kode yang akan di jalankan jika  request ke API gagal  (statur HTTP ! = 200)
        } else {
          throw Exception('failed to load news, please try again later.');
        } 
        // kode diajlankan ketika terjadi erroe lain, selain yang sudah di buat diatas
      // e = error
    } catch (e) {
      throw Exception('Another problem occurs, please try again later');
    }
  }

  Future<NewsResponse> searchNews({
    // ini adalah nilai yang di mauskan ke kolon pencarian 
    required String query,
    // mendefinisikan halaman berita ke berapa
    int page = 1,
    // berapa bannyak berita yang inginkan di tampilkan ketika sekali rendering data
    int pageSize = 20,
    String? sortBy,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'apiKey':_apiKey,
        'q': query,
        'page':page.toString(),
        'pageSize':pageSize.toString()
      };

    if (sortBy != null && sortBy.isEmpty) {
      queryParams['sortBy'] = sortBy;
    }
   final uri = Uri.parse('$_baseUrl${Constants.everything}')
          .replace(queryParameters: queryParams);

    final response = await http.get(uri);

 if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return NewsResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
         throw Exception('another problem occurs, please try again later.');
    }
  }
}