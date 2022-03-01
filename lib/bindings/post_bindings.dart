import 'package:crypto_learn/controllers/auth_controller.dart';
import 'package:crypto_learn/controllers/home_controller.dart';
import 'package:crypto_learn/controllers/post_view_controller.dart';
import 'package:crypto_learn/controllers/posts_controller.dart';
import 'package:crypto_learn/controllers/root_controller.dart';
import 'package:get/get.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PostViewController());
  }
}
