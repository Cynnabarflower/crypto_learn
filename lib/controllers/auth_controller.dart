import 'package:crypto_learn/controllers/posts_controller.dart';
import 'package:crypto_learn/repositories/user_repository.dart';
import 'package:crypto_learn/services/auth_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../config.dart';

class AuthController extends GetxController {
  PlatformFile? titleImage;
  String? titleUrl;

  late UserRepository _userRepository;

  AuthController() {
    _userRepository = UserRepository();
  }

  bool isAuth() {
    var u = Get.find<AuthService>().user.value;
    return u.auth;
  }

  Future googleSignIn() async {
    await _userRepository.signInWithGoogle();
  }

  Future signOut() async {
    await _userRepository.signOut().then((value) => Get.find<AuthService>().user.refresh());
  }

  Future upsert() {
    return _userRepository.update(Get.find<AuthService>().user.value);
  }

  Future refreshUser() async {
    return Get.find<AuthService>().getCurrentUser();
  }

  Future changeAvatar() async {
    titleUrl = null;
    titleImage = null;
    await showTitleImageDialog(Get.context);
    if (titleImage != null) {
      titleUrl = await Get.find<PostsController>().uploadFile(titleImage!);
    }
    if (titleUrl != null) {
      _userRepository.update((await _userRepository.getCurrentUser())
        ..imageUrl = titleUrl);
    }
    return refreshUser();
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
                          );
                          if (result?.files.single.name !=
                              null) {
                            setState(() {
                              filename.text =
                                  result!.files.single.name;
                               titleImage = result!.files.first;
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
                        titleUrl = null;
                        titleImage = result!.files.single;
                        Get.back();
                      } else {
                        titleImage = null;
                        titleUrl = url.text;
                        Get.back();
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


}