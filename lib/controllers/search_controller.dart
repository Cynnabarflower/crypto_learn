import 'package:crypto_learn/controllers/post_view_controller.dart';
import 'package:crypto_learn/controllers/posts_controller.dart';
import 'package:crypto_learn/models/post.dart';
import 'package:crypto_learn/services/auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {

  RxList<Post> posts = RxList<Post>.empty();
  var isLoading = false.obs;
  var user = Get.find<AuthService>().user;
  RxString query = ''.obs;

  @override
  void onInit() {
    super.onInit();
    refreshSearch();
  }

  Future<bool> loadMorePosts() async {
    isLoading.trigger(true);
    posts.addAll(await Get.find<PostsController>().getPosts(query: query.value, startAfter: posts.isEmpty ? null : posts.last));
    isLoading.trigger(false);
    return true;
  }

  Future refreshSearch({String query = ''}) async {
    isLoading.trigger(true);
    await Get.find<AuthService>().getCurrentUser();
    var p = await Get.find<PostsController>().getPosts(query: query);
    posts.assignAll(p);
    isLoading.trigger(false);
  }
}