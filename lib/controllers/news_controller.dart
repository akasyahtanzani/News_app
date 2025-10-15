import 'package:get/get.dart';
import 'package:news/models/news_articles.dart';
import 'package:news/services/news_services.dart';
import 'package:news/utils/constants.dart';

class NewsController  extends GetxController {
  // untuk meperoses request yang sudah di buat oles newservices
  final NewsServices _newsServices = NewsServices();

// setter
// obsevable variable (variable yang bisa berubah)
  final _isLoading = false.obs; // apakah aplikasi dengan memuat berita 
  final _articles = <NewsArticles>[].obs; // ini untuk nampilkan daftar berita yang sudah/berhasil di dapat
  final _selectedCategory = 'general'.obs;  //untuk  handle kategori yg sedang  di pilih
  final _error =''.obs; //kalo ada kesalahan pesan error akan di simpan disini

  // Getters
// getter ini, seperti jendela untuk melihat isi variable yg sudh di devinisikan
// dengan ini ui bisa dengan mudah melihat dat adari controller
bool get isLoading => _isLoading.value;
List<NewsArticles> get articles => _articles;
String get selectedCategory => _selectedCategory.value;
String get Error => _error.value;
List<String> get Categories => Constants.categories;

// begitu aplikasi di buka, aplikais langsung menampilkan berita utama
// dari endpoint top-headlines
// TODO: Fetching data dari endpoint top-headlines

Future<void> fetchTopHeadingLines({String? category}) async{
  // blok ini akn di jalankan ketika REST API berhasik berkomunikasi dengan srve
try {
  _isLoading.value=true;
  _error.value= '';

  final response = await _newsServices.getTopHeadLines(
    category: category?? _selectedCategory.value,
  );

  _articles.value= response.articles;
} catch (e) {
  _error.value = e.toString();
  Get.snackbar(
    'Error',
    'Failed TO load news: ${e.toString()}',
    snackPosition: SnackPosition.BOTTOM,
  );
  // finally akan tetap di avecute setelah salah satu dari blok try atau catch sudah berhasil mendapatkan hasil
}finally {
  _isLoading.value= false;
}
}

Future<void> refreshNews() async{
  await fetchTopHeadingLines();
}

void selectCategory(String category) {
  if (_selectedCategory.value != category) {
    _selectedCategory.value = category;
    fetchTopHeadingLines(category: category);
  }
}

Future<void>searchNews(String query) async{
  if (query.isEmpty) return;
  try {
    _isLoading.value = true;
    _error.value = '';

    final response = await _newsServices.searchNews(query:query);
    _articles.value = response.articles;
  } catch (e) {
    _error.value = e.toString();
    Get.snackbar(
      'Error',
      'Failed to search news: ${e.toString()}',
      snackPosition: SnackPosition.BOTTOM
    );
  }finally {
    _isLoading.value= false;
  }
}
}
