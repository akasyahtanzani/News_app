import 'package:get/get.dart';
import 'package:news/controllers/favorite_controller.dart';
import 'package:news/controllers/news_controller.dart';

class AppBindings implements Bindings {
  @override
 void dependencies(){
  Get.put<NewsController>(NewsController(),permanent: true);
    Get.put(FavoriteController()); 
 }
  
}