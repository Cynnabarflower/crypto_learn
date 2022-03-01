import 'package:crypto_learn/controllers/auth_controller.dart';
import 'package:crypto_learn/services/auth_service.dart';
import 'package:crypto_learn/widgets/signInButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../config.dart';

class AuthView extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.backgroundGray,
        body: SafeArea(child: controller.isAuth() ? userTile() : authScreen()),
      ),
    );
  }

  Widget authScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: Html(data: authData)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: MySignInButton(
                  onTap: () {
                    controller.googleSignIn();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Image.asset(
                          'assets/google.png',
                          width: 30,
                          height: 30,
                        ),
                      ),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget userTile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 250,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Container(
                    height: 200,
                    padding: EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 24, bottom: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: AppColors.widgetGray,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(
                          () => TextField(
                            controller: TextEditingController()
                              ..text =
                                  Get.find<AuthService>().user.value.name,
                            onChanged: (value) {
                              Get.find<AuthService>().user.value.firstName = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: InkWell(
                            child: Container(
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[800],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Text('Save'),
                            ),
                            onTap: () {
                              controller.upsert();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: Obx(
                    () => ClipOval(
                      child: InkWell(
                        onTap: () {
                          print('tap');
                          controller.changeAvatar();
                        },
                        child: Container(
                          width: 64,
                          height: 64,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(32)),
                            color: AppColors.lightGray,
                          ),
                          child: (Get.find<AuthService>()
                                          .user
                                          .value
                                          .imageUrl ??
                                      '')
                                  .isEmpty
                              ? null
                              : Container(
                                  alignment: Alignment.center,
                                  child: Image.network(Get.find<AuthService>()
                                      .user
                                      .value
                                      .imageUrl!,
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                    height: 64,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: InkWell(
            child: Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Text('Sign out'),
            ),
            onTap: () {
              controller.signOut();
            },
          ),
        )
      ],
    );
  }

  var authData = '''
<p><strong>Crypto learn</strong> - это бла бла бла&nbsp;бла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла блабла бла бла</p>
<p><strong><img src="https://www.interactivebrokers.com/images/web/cryptocurrency-hero.jpg" width="494" height="329" alt="" style="display: block; margin-left: auto; margin-right: auto;" /></strong></p> ''';
}
