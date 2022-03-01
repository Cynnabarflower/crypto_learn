import 'package:crypto_learn/bindings/post_bindings.dart';
import 'package:crypto_learn/config.dart';
import 'package:crypto_learn/controllers/post_view_controller.dart';
import 'package:crypto_learn/helper.dart';
import 'package:crypto_learn/models/post.dart';
import 'package:crypto_learn/views/post_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class ExpandablePostTileWidget extends StatelessWidget {

  Post currentPost;
  bool replace = false;
  var expanded = false.obs;

  ExpandablePostTileWidget(this.currentPost, {this.replace = false});

  Widget htmlBase() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRect(
        child: Html(
          data: currentPost.body,
          onImageTap: (url, context, attributes, element) {
            onTap();
          },
        ),
      ),
    );
  }

  void onTap() {
    if (replace) {
      Get.off(() => PostView(), arguments: currentPost, binding: PostBinding(), preventDuplicates: false);
    } else {
      Get.to(() => PostView(), arguments: currentPost, binding: PostBinding(), preventDuplicates: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Obx(
        () => Container(
          height: expanded.isTrue ? null : 300,
          color: AppColors.widgetGray,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                (expanded.isTrue) ? ConstrainedBox(child: htmlBase(), constraints: BoxConstraints(minHeight: 200),) : Expanded(child: htmlBase(),),
                Obx(
                  () => InkWell(
                    onTap: () {
                      expanded.toggle();
                    },
                    child: Container(
                      height: 30,
                      color: AppColors.widgetGray,
                      padding: const EdgeInsets.only(right: 16.0),
                      alignment: Alignment.centerRight,
                      child: expanded.isTrue ? const Text('Less') : const Text('More'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    runSpacing: 8.0,
                    spacing: 8.0,
                    children: [
                      ...currentPost.tags.map((e) => Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(
                                255,
                                150 + (e.hashCode % 100),
                                120 + ((e.hashCode + 123) % 80),
                                120 + ((e.hashCode + 456) % 80)),
                            borderRadius:
                            BorderRadius.all(Radius.circular(16.0))),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        child: Text(e),
                      ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(currentPost.date == null
                          ? ' '
                          : '${currentPost.date!.customDataHeaderText()}'),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.thumb_up_alt_outlined, color: AppColors.white,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}