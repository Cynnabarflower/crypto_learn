import 'package:crypto_learn/controllers/root_controller.dart';
import 'package:crypto_learn/controllers/search_controller.dart';
import 'package:crypto_learn/services/auth_service.dart';
import 'package:crypto_learn/widgets/expandable_post_tile_widget.dart';
import 'package:crypto_learn/widgets/post_tile_widget.dart';
import 'package:crypto_learn/widgets/search_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../config.dart';

class SearchView extends GetView<SearchController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: Container(
        child: LazyLoadScrollView(
            onEndOfPage: () {
              controller.loadMorePosts();
            },
            isLoading: controller.isLoading.isTrue,
            child: Obx(
              () => ListView(
                addAutomaticKeepAlives: true,
                children: [
                  topRow(),
                  banner(),
                  recentPosts(),
                  ...controller.posts.map((post) => ExpandablePostTileWidget(post))
                ],
              ),
            )
        ),
      ),
    );
  }

  Widget recentPosts() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: Text('Recent posts:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
          ),
          Container(
            height: 120,
            child: Obx(
                  () => ListView(
                scrollDirection: Axis.horizontal,
                itemExtent: 120 * 3,
                children: [
                  ...controller.posts.map((element) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: PostTileWidget(element),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget banner() {
    return Container(
      height: 160,
      child: Image.asset(
        'assets/placeholder.jpg',
        fit: BoxFit.fill,
      ),
    );
  }

  Widget topRow() {
    return Container(
      color: AppColors.backgroundGray,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.find<RootController>().changePage(3, animate: true);
            },
            child: Obx(
                  () => CircleAvatar(
                backgroundImage: (Get.find<AuthService>().user.value.imageUrl ?? '').isEmpty ? null : NetworkImage(Get.find<AuthService>().user.value.imageUrl!),
                backgroundColor: AppColors.white,
                radius: 24,
              ),
            ),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(top:8.0,bottom:8.0,left: 8.0),
            child: SearchWidget(controller.query.value),
          ))
        ],
      ),
    );
  }
}