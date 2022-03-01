import 'package:crypto_learn/config.dart';
import 'package:crypto_learn/models/post.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:html/parser.dart' as htmlparser;
import 'posts_controller.dart';

class PostViewController extends GetxController {
  Post? currentPost;
  RxList<Post> recommendations = RxList<Post>.empty();
  var loadingRecommendations = false.obs;
  HtmlEditorController htmlEditorController = HtmlEditorController();
  var dateController = TextEditingController();
  var tagsController = TextEditingController();
  Map<String, PlatformFile> images = {};
  PlatformFile? titleImage;
  RxBool saving = false.obs;

  @override
  void onInit() {
    currentPost = Get.arguments;
    dateController.text = currentPost!.date?.toString() ?? '';
    images.clear();
    loadRecommendations();
    super.onInit();
  }

  Future loadRecommendations() async {
    loadingRecommendations.trigger(true);
    var posts = (await Get.find<PostsController>().getPosts()).toList();
    posts.removeWhere((e) => e.id == currentPost?.id);
    recommendations.assignAll(posts);
    loadingRecommendations.trigger(false);
  }

  Future<bool> upsert() async {
    var p = await Get.find<PostsController>().upsert(currentPost!, images: images, titleImage: titleImage);
    if (p != null) {
      currentPost = p;
    }
    return p != null;
  }

  Future delete() async {
    if (currentPost!.id.isNotEmpty) {
      await Get.find<PostsController>().deletePost(currentPost!);
    }
  }

  Future savePost() async {
    saving.trigger(true);
    currentPost!.body = await htmlEditorController.getText();
    bool upserted = false;
    try {
      upserted = await upsert();
    } catch (_) {
      upserted = false;
    }
    finally {
      saving.trigger(false);
    }
    ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
      backgroundColor: AppColors.widgetGray,
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 30,
            alignment: Alignment.center,
            child: Text(upserted ? 'Saved!' : 'Error')),
      ),
    ));
  }
}