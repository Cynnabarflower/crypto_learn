import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_learn/config.dart';
import 'package:crypto_learn/controllers/auth_controller.dart';
import 'package:crypto_learn/controllers/post_view_controller.dart';
import 'package:crypto_learn/helper.dart';
import 'package:crypto_learn/services/auth_service.dart';
import 'package:crypto_learn/views/post_edit.dart';
import 'package:crypto_learn/widgets/post_tile_widget.dart';
import 'package:crypto_learn/widgets/tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../bindings/post_bindings.dart';

class PostView extends GetView<PostViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundGray,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(controller.currentPost!.title)),
            if (Get.find<AuthService>().user.value.admin) InkWell(
              onTap: () {
                Get.to(() => PostEdit(), binding: PostBinding(), arguments: controller.currentPost!);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.edit, color: AppColors.white,),
              ),
            )
          ],
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.white,
                )),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.currentPost!.titleImageUrl != null)
              CachedNetworkImage(
                imageUrl: controller.currentPost!.titleImageUrl!,
                fit: BoxFit.fitWidth,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                child: Html(
                  data: controller.currentPost!.body,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                runSpacing: 8.0,
                spacing: 8.0,
                children: [
                  ...controller.currentPost!.tags.map((e) => TagWidget(e))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(controller.currentPost?.date == null
                      ? ' '
                      : '${controller.currentPost!.date!.customDataHeaderText()}'),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(Icons.thumb_up_alt_outlined, color: AppColors.white,),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                color: AppColors.widgetGray,
                height: 42,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   height: 1,
                    //   width: 30,
                    //   color: AppColors.white,
                    // ),
                    // const Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 8.0),
                    //   child: Icon(Icons.insert_drive_file_outlined, color: AppColors.white,),
                    // ),
                    const Text('Recommendations')
                  ],
                ),
              ),
            ),
            Obx(
                  () => ListView(
                shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ...controller.recommendations.map((post) => PostTileWidget(post, separate: false,replace: true,)),
                  if (controller.loadingRecommendations.isTrue) Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
