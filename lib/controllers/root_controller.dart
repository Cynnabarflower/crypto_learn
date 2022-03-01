import 'package:crypto_learn/controllers/auth_controller.dart';
import 'package:crypto_learn/controllers/home_controller.dart';
import 'package:crypto_learn/controllers/rooms_controller.dart';
import 'package:crypto_learn/controllers/search_controller.dart';
import 'package:crypto_learn/views/auth_view.dart';
import 'package:crypto_learn/views/home_view.dart';
import 'package:crypto_learn/views/notifications_view.dart';
import 'package:crypto_learn/views/profile_view.dart';
import 'package:crypto_learn/views/search_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RootController extends GetxController {
  var page = 0.obs;
  final pageController = PageController();

  var pages = [
    HomeView(),
    NotificationsView(),
    SearchView(),
    AuthView(),
  ];

  Widget get currentPage => pages[page.value];

  void changePage(int page, {bool animate = false}) {
    this.page.trigger(page);
    updatePage(page);
    if (animate) {
      pageController.animateToPage(
          page, duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn);
    }
  }

  void updatePage(page) async {
    switch (page) {
      case 0:
        await Get.find<HomeController>().refreshHome();
        break;
      case 1:
        await Get.find<RoomsController>().refreshRooms();
        break;
      case 2:
        await Get.find<SearchController>().refreshSearch();
        break;
      case 3:
        await Get.find<AuthController>().refreshUser();
        break;
    }
  }
}