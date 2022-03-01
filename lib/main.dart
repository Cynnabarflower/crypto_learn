import 'package:crypto_learn/config.dart';
import 'package:crypto_learn/views/auth_view.dart';
import 'package:crypto_learn/views/root_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'bindings/root_bindings.dart';
import 'providers/firebase_provider.dart';
import 'services/auth_service.dart';

Future initServices() async {
  Get.log('starting services ...');
  await GetStorage.init();
  // await Get.putAsync(() => TranslationService().init());
  // await Get.putAsync(() => GlobalService().init());
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyCEW0K0g17kRmBzG0aAj8-xfZDvnv2E0YM',
          appId: '1:527335365656:web:4463245108c38ed44af76d',
          messagingSenderId: 'G-X6WR6K7C2H',
          projectId: 'crypto-learn-b4f76',
        storageBucket: "crypto-learn-b4f76.appspot.com",
      )
    );
  } else {
    await Firebase.initializeApp();
  }
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => FirebaseProvider().init());
  Get.log('All services started...');
}

void setupChats() {
  FirebaseChatCore.instance.setConfig(
    const FirebaseChatCoreConfig(
      null,
      'rooms',
      'users'
    )
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  setupChats();
  runApp(GetMaterialApp(
    color: AppColors.widgetGray,
    theme: ThemeData(
      backgroundColor: AppColors.backgroundGray,
      primaryColor: AppColors.widgetGray,
      bottomAppBarColor: AppColors.widgetGray,
      dialogBackgroundColor: AppColors.backgroundGray,
      buttonColor: AppColors.widgetGray,
      textSelectionColor: AppColors.backgroundGray,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.widgetGray,
        unselectedItemColor: AppColors.white,
        selectedItemColor: Colors.lightBlueAccent,
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: AppColors.white),
        bodyText2: TextStyle(color: AppColors.white),
        headline1:  TextStyle(color: AppColors.white),
        headline2: TextStyle(color: AppColors.white),
        headline3: TextStyle(color: AppColors.white),
        subtitle1: TextStyle(color: AppColors.white),
        subtitle2: TextStyle(color: AppColors.white),
        button: TextStyle(color: AppColors.white),
        caption: TextStyle(color: AppColors.white),
        headline4: TextStyle(color: AppColors.white),
        headline5: TextStyle(color: AppColors.white),
        headline6: TextStyle(color: AppColors.white),
        overline: TextStyle(color: AppColors.white),
      ),
    ),
    initialBinding: RootBinding(),
    home: RootView(),
  ));
}