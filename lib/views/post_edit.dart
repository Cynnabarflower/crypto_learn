import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_learn/config.dart';
import 'package:crypto_learn/controllers/post_view_controller.dart';
import 'package:crypto_learn/widgets/tag_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class PostEdit extends GetView<PostViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(controller.currentPost!.id)),
            if (controller.currentPost!.id.isNotEmpty) Obx(
                  () => InkWell(
                onTap: controller.saving.isTrue ? null : () {
                  controller.savePost();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.center,
                      child: controller.saving.isTrue ? Container(
                        width: 24,
                        height: 24,
                        child: const CircularProgressIndicator(),
                      ) : const Icon(Icons.save, color: AppColors.white,)
                  ),
                ),
              ),
            ),
            if (controller.currentPost!.id.isNotEmpty) InkWell(
              onTap: () {
                showDialog(context: context, builder: (context) {
                  return Center(
                    child: Material(
                      color: AppColors.backgroundGray,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: Container(
                        width: 200,
                        height: 120,
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delete?'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              MaterialButton(onPressed: (){
                                controller.delete().then((value) {
                                  Get.until((route) => route.isFirst);
                                });
                              },
                                child: Text('Yes', style: TextStyle(color: AppColors.white),),
                              color: Colors.redAccent[200],
                              ),
                                MaterialButton(onPressed: (){
                                  Get.back();
                                },
                                  color: AppColors.widgetGray,
                                  child: Text('No', style: TextStyle(color: AppColors.white),),
                                ),
                            ],)
                          ],
                        ),
                      ),
                    ),
                  );
                },
                );
              },
              child: Icon(Icons.delete_outline, color: AppColors.white,),
            )
          ],
        ),
        backgroundColor: AppColors.backgroundGray,
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
      body: StatefulBuilder(
        builder: (context, ss) => Padding(
          padding: EdgeInsets.only(bottom: kIsWeb ? 0 : MediaQuery.of(context).viewInsets.bottom),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    titleImageWidget(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: TextEditingController()
                            ..text = controller.currentPost!.title,
                          decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(color: AppColors.white)),
                          style: TextStyle(color: AppColors.white),
                          onChanged: (value) {
                            controller.currentPost!.title = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    width: 280,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: TextFormField(
                          controller: controller.dateController,
                          onChanged: (value) {
                            controller.currentPost!.date =
                                DateTime.tryParse(value);
                          },
                          decoration: InputDecoration(
                              labelText: "Date",
                              filled: true,
                              labelStyle: TextStyle(color: AppColors.white),
                              suffixIcon: InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  showDatePicker(
                                    builder: (context, child) {
                                      return PointerInterceptor(child: child!);
                                    },
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime
                                              .fromMillisecondsSinceEpoch(0),
                                          lastDate: DateTime.now()
                                              .add(Duration(days: 1000)))
                                      .then((value) {
                                    if (value != null) {
                                      controller.dateController.text =
                                          value.toString();
                                      controller.currentPost!.date = value;
                                      ss(() {});
                                    } else {}
                                  });
                                },
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: AppColors.white,
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: TextEditingController()
                          ..text = controller.currentPost!.likes.value.toString(),
                        decoration: InputDecoration(
                            labelText: 'Likes',
                            labelStyle: TextStyle(color: AppColors.white)
                        ),
                        style: TextStyle(color: AppColors.white),
                        onChanged: (value) {
                          var i = int.tryParse(value);
                          controller.currentPost!.likes.trigger(i ?? 0);
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller.tagsController,
                        decoration: InputDecoration(
                            labelText: 'Add tag',
                            labelStyle: TextStyle(color: AppColors.white),
                            suffixIcon: InkWell(
                              onTap: () {
                                if (controller.tagsController.text.trim().isNotEmpty) {
                                  controller.currentPost!.tags
                                      .add(
                                      controller.tagsController.text.trim());
                                  ss(() {});
                                }
                              },
                              child: const Icon(
                                Icons.add,
                                color: AppColors.white,
                              ),
                            )),
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  direction: Axis.horizontal,
                  verticalDirection: VerticalDirection.up,
                  runSpacing: 8.0,
                  spacing: 8.0,
                  children: [
                    ...controller.currentPost!.tags.map((e) => GestureDetector(
                        onTap: () {
                          controller.currentPost!.tags.remove(e);
                          ss(() {});
                        },
                        child: TagWidget(e)))
                  ],
                ),
              ),
              // Obx(
              //       () => InkWell(
              //     onTap: controller.saving.isTrue ? null : () {
              //       controller.savePost();
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Container(
              //           height: 50,
              //           color: AppColors.widgetGray,
              //           alignment: Alignment.center,
              //           child: Text(controller.saving.isTrue ? 'Saving...' : 'Save')
              //       ),
              //     ),
              //   ),
              // ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 300
                ),
                child: HtmlEditor(
                  controller: controller.htmlEditorController,
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.aboveEditor,
                    toolbarType: ToolbarType.nativeGrid,
                    buttonColor: AppColors.white,
                    dropdownIconColor: AppColors.white,
                    dropdownBackgroundColor: AppColors.backgroundGray,
                    onButtonPressed: (ButtonType type, bool? status,
                        Function()? updateStatus) {
                      if (type == ButtonType.picture) {
                        showImageDialog(context);
                        return false;
                      }
                      return true;
                    },
                  ),
                  htmlEditorOptions: HtmlEditorOptions(
                    shouldEnsureVisible: true,
                    darkMode: true,
                      autoAdjustHeight: true,

                      initialText: controller.currentPost!.body
                  ),
                  otherOptions: OtherOptions(height: 550),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showImageDialog(context) async {
    final filename = TextEditingController();
    final url = TextEditingController();
    final urlFocus = FocusNode();
    FilePickerResult? result;
    String? validateFailed;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return PointerInterceptor(
            child: StatefulBuilder(builder:
                (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: AppColors.backgroundGray,
                title: Text('Insert Image'),
                scrollable: true,
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select from files',
                          style: TextStyle(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          result = await FilePicker.platform
                              .pickFiles(
                            type: FileType.image,
                            withData: true,
                            allowedExtensions: controller.htmlEditorController.toolbar?.widget.htmlToolbarOptions
                                .imageExtensions,
                          );
                          if (result?.files.single.name !=
                              null) {
                            setState(() {
                              filename.text =
                                  result!.files.single.name;
                              controller.images[result!.files.first.name] = result!.files.first;
                            });
                          }
                        },
                        child: Text('Choose image',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color)),
                      ),
                      TextFormField(
                          controller: filename,
                          readOnly: true,
                          decoration: InputDecoration(
                            suffixIcon: result != null
                                ? IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    result = null;
                                    filename.text = '';
                                  });
                                })
                                : Container(height: 0, width: 0),
                            errorText: validateFailed,
                            errorMaxLines: 2,
                            border: InputBorder.none,
                          )),
                      SizedBox(height: 20),
                      Text('URL',
                          style: TextStyle(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      TextField(
                        controller: url,
                        focusNode: urlFocus,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'URL',
                          errorText: validateFailed,
                          errorMaxLines: 2,
                            filled: true,
                            fillColor: AppColors.white
                        ),
                      ),
                    ]),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (filename.text.isEmpty &&
                          url.text.isEmpty) {
                        setState(() {
                          validateFailed =
                          'Please either choose an image or enter an image URL!';
                        });
                      } else if (filename.text.isNotEmpty &&
                          url.text.isNotEmpty) {
                        setState(() {
                          validateFailed =
                          'Please input either an image or an image URL, not both!';
                        });
                      } else if (filename.text.isNotEmpty &&
                          result?.files.single.bytes != null) {
                        var base64Data = base64
                            .encode(result!.files.single.bytes!);
                        var proceed = await controller.htmlEditorController.toolbar?.widget
                            .htmlToolbarOptions
                            .mediaUploadInterceptor
                            ?.call(result!.files.single,
                            InsertFileType.image) ??
                            true;
                        if (proceed) {
                          controller.htmlEditorController.insertHtml(
                              "<img src='data:image/${result!.files.single.extension};base64,$base64Data' data-filename='${result!.files.single.name}'/>");
                        }
                        Navigator.of(context).pop();
                      } else {
                        var proceed = await controller.htmlEditorController.toolbar?.widget
                            .htmlToolbarOptions
                            .mediaLinkInsertInterceptor
                            ?.call(url.text,
                            InsertFileType.image) ??
                            true;
                        if (proceed) {
                          controller.htmlEditorController
                              .insertNetworkImage(url.text);
                        }
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('OK'),
                  )
                ],
              );
            }),
          );
        });
  }

  Future showTitleImageDialog(context) async {
    final filename = TextEditingController();
    final url = TextEditingController();
    final urlFocus = FocusNode();
    FilePickerResult? result;
    String? validateFailed;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return PointerInterceptor(
            child: StatefulBuilder(builder:
                (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: AppColors.backgroundGray,
                title: Text('Insert Image'),
                scrollable: true,
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select from files',
                          style: TextStyle(
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          result = await FilePicker.platform
                              .pickFiles(
                            type: FileType.image,
                            withData: true,
                            allowedExtensions: controller.htmlEditorController.toolbar?.widget.htmlToolbarOptions
                                .imageExtensions,
                          );
                          if (result?.files.single.name !=
                              null) {
                            setState(() {
                              filename.text =
                                  result!.files.single.name;
                              controller.titleImage = result!.files.first;
                            });
                          }
                        },
                        child: Text('Choose image',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.color)),
                      ),
                      TextFormField(
                          controller: filename,
                          readOnly: true,
                          decoration: InputDecoration(
                            suffixIcon: result != null
                                ? IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    result = null;
                                    filename.text = '';
                                  });
                                })
                                : Container(height: 0, width: 0),
                            errorText: validateFailed,
                            errorMaxLines: 2,
                            border: InputBorder.none,
                          )),
                      SizedBox(height: 20),
                      Text('URL', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      TextField(
                        controller: url,
                        focusNode: urlFocus,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'URL',
                          errorText: validateFailed,
                          errorMaxLines: 2,
                          filled: true,
                          fillColor: AppColors.white
                        ),
                      ),
                    ]),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (filename.text.isEmpty &&
                          url.text.isEmpty) {
                        setState(() {
                          validateFailed =
                          'Please either choose an image or enter an image URL!';
                        });
                      } else if (filename.text.isNotEmpty &&
                          url.text.isNotEmpty) {
                        setState(() {
                          validateFailed =
                          'Please input either an image or an image URL, not both!';
                        });
                      } else if (filename.text.isNotEmpty &&
                          result?.files.single.bytes != null) {
                        controller.titleImage = result!.files.single;
                        Navigator.of(context).pop();
                      } else {
                        controller.titleImage = null;
                        controller.currentPost!.titleImageUrl = url.text;
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('OK'),
                  )
                ],
              );
            }),
          );
        });
  }

  Widget titleImageWidget() {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(child: Builder(
            builder: (context) {
              return InkWell(
                onTap: () {
                },
                child: Container(
                  child: StatefulBuilder(
                    builder: (context, ss) {
                      Widget? _child;
                      if (controller.titleImage != null) {
                        _child = Image.memory(controller.titleImage!.bytes!, fit: BoxFit.cover,);
                      } else if (controller.currentPost!.titleImageUrl != null) {
                        _child = CachedNetworkImage(imageUrl: controller.currentPost!.titleImageUrl!, fit: BoxFit.cover);
                      } else {
                        _child = Container(padding: const EdgeInsets.all(4.0) ,alignment: Alignment.center, child: Text('Tap to select title image', textAlign: TextAlign.center,),);
                      }
                      return InkWell(
                        onTap: () {
                          showTitleImageDialog(Get.context).then((value) {
                            ss((){});
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          color: AppColors.widgetGray,
                          child: _child,
                        ),
                      );
                    }
                  ),
                ),
              );
            }
        ),)
    );
  }

}
