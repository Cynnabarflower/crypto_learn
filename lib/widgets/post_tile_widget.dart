import 'package:crypto_learn/bindings/post_bindings.dart';
import 'package:crypto_learn/config.dart';
import 'package:crypto_learn/controllers/post_view_controller.dart';
import 'package:crypto_learn/models/post.dart';
import 'package:crypto_learn/views/post_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';


class PostTileWidget extends StatelessWidget {

  Post currentPost;
  bool replace = false;
  bool separate = false;

  PostTileWidget(this.currentPost, {this.replace = false, this.separate = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (replace) {
            Get.off(() => PostView(), arguments: currentPost, binding: PostBinding(), preventDuplicates: false);
          } else {
            Get.to(() => PostView(), arguments: currentPost, binding: PostBinding(), preventDuplicates: false);
          }
        },
        child: Builder(builder: (context) {
          if (separate) {
            return Container(
              height: 100,
              child: Row(
                children: [
                  leading(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 2.0, bottom: 2.0),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: titleRow(),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.widgetGray,
              ),
              height: 100,
              child: Row(
                children: [
                  leading(),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 2.0, bottom: 2.0),
                      alignment: Alignment.topLeft,
                      child: titleRow(),
                    ),
                  )
                ],
              ),
            ),
          );
        },),
      ),
    );
  }

  Widget titleRow() {
    return Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(currentPost.title, style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ), maxLines: 3,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  Icon(Icons.thumb_up, color: AppColors.white.withOpacity(.8), size: 16,),
                  Text(' ${currentPost.likes.value}', style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppColors.white.withOpacity(0.8)
                  ),),
                ],
              ),
            )
          ],
        ));
  }

  Widget leading() {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: AspectRatio(aspectRatio: 1, child: currentPost.titleImageUrl == null ? Container(color: AppColors.white,) : LayoutBuilder(
          builder: (context, constrains) {
            return Container(
              color: AppColors.widgetGray,
              child: currentPost.titleImageUrl == null ? null : Image.network(currentPost.titleImageUrl!, fit: BoxFit.cover),
            );
          }
        ),)
    );
  }

}