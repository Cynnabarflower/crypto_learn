import 'package:crypto_learn/controllers/auth_controller.dart';
import 'package:crypto_learn/controllers/home_controller.dart';
import 'package:crypto_learn/controllers/post_view_controller.dart';
import 'package:crypto_learn/controllers/posts_controller.dart';
import 'package:crypto_learn/controllers/rooms_controller.dart';
import 'package:crypto_learn/controllers/root_controller.dart';
import 'package:crypto_learn/controllers/search_controller.dart';
import 'package:crypto_learn/providers/firebase_provider.dart';
import 'package:get/get.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FirebaseProvider());
    Get.put(RootController());
    Get.put(PostsController());
    Get.put(RoomsController());
    Get.put(AuthController());
    Get.put(HomeController());
    Get.put(SearchController());
  }
}
