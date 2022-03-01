import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_learn/bindings/post_bindings.dart';
import 'package:crypto_learn/controllers/home_controller.dart';
import 'package:crypto_learn/models/post.dart';
import 'package:crypto_learn/views/post_edit.dart';
import 'package:crypto_learn/widgets/post_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../config.dart';

class HomeView extends GetView<HomeController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Container(
          child: Obx(
            () => LazyLoadScrollView(
              onEndOfPage: () {
                controller.loadMorePosts();
              },
              isLoading: controller.isLoading.isTrue,
              child: Obx(
                  () => ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:8.0, bottom: 12.0),
                      child: Obx(() => Text(controller.user.value.name.isEmpty ? ' ':'Hello, ${controller.user.value.name}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),)),
                    ),
                    Obx(() => controller.user.value.premium ? ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: Container(
                        height: 140,
                        child: Image.asset(
                          'assets/placeholder.jpg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ) : SizedBox(
                      height: 0,
                      width: 0,
                    )),
                    Obx(() => controller.user.value.admin ? InkWell(
                      onTap: () {
                        Get.to(() => PostEdit(), binding: PostBinding(), arguments: Post());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                        child: Container(
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: AppColors.widgetGray,
                          ),
                          child: Text('+ Add post'),
                        ),
                      ),
                    ) : SizedBox(
                      height: 0,
                      width: 0,
                    )),
                    ...controller.posts.map((post) => PostTileWidget(post))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}