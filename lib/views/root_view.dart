import 'package:crypto_learn/config.dart';
import 'package:crypto_learn/controllers/root_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootView extends GetView<RootController> {

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.backgroundGray,
        body: PageView(
          controller: controller.pageController,
            children: [
              ...controller.pages
            ],
          onPageChanged: (value) {
            controller.page.trigger(value);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,),
              label: 'Profile',
            ),
          ],
          currentIndex: controller.page.value,
          onTap: (value) {
            controller.changePage(value, animate: true);
          },
        ),
      ),
    );
  }
}