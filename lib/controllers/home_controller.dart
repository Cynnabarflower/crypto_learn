import 'package:crypto_learn/controllers/post_view_controller.dart';
import 'package:crypto_learn/controllers/posts_controller.dart';
import 'package:crypto_learn/models/post.dart';
import 'package:crypto_learn/services/auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  RxList<Post> posts = RxList<Post>.empty();
  var isLoading = false.obs;
  var user = Get.find<AuthService>().user;

  @override
  void onInit() {
    super.onInit();
    refreshHome();
  }

  Future loadMorePosts() async {
    isLoading.trigger(true);
    posts.addAll(await Get.find<PostsController>().getPosts(startAfter: posts.isEmpty ? null : posts.last));
    isLoading.trigger(false);
  }

  Future refreshHome() async {
    isLoading.trigger(true);
    await Get.find<AuthService>().getCurrentUser();
    posts.assignAll(await Get.find<PostsController>().getPosts());
    isLoading.trigger(false);
  }
}