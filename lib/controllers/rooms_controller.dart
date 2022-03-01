import 'package:crypto_learn/chat/chat.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:crypto_learn/providers/firebase_provider.dart';
import 'package:crypto_learn/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import '../config.dart';
import '../controllers/rooms_controller.dart';
import '../controllers/root_controller.dart';
import 'package:crypto_learn/models/user.dart' as u;

class RoomsController extends GetxController {

  bool error = false;
  bool initialized = false;
  Rx<User?> user = Rx(null);
  var loadingRooms = false.obs;
  RxList<types.Room> rooms = RxList.empty();
  Rx<Widget?> chatsPage = Rx(null);


  @override
  void onInit() {
    initializeFlutterFire();
    super.onInit();
  }

  void handlePressed(BuildContext context) async {
    types.User _supportUser;
    try {
      _supportUser = types.User.fromJson((await Get.find<FirebaseProvider>().getSupportUser())?.toJson() ?? <String, dynamic>{});
    } catch (e){
      printError(info: 'Support user not found');
      rethrow;
    }

    final room = await FirebaseChatCore.instance.createRoom(_supportUser);
    rooms.value = [room];
    chatsPage.trigger(ChatPage(
      room: room,
    ));
  }

  Stream<List<types.Room>> supportRooms(u.User supportUser) {
    final collection = FirebaseChatCore.instance.getFirebaseFirestore()
        .collection(FirebaseChatCore.instance.config.roomsCollectionName)
        .where('userIds', arrayContains: supportUser.uid);

    return collection.snapshots().asyncMap(
          (query) => processRoomsQuery(
        FirebaseChatCore.instance.firebaseUser!, FirebaseChatCore.instance.getFirebaseFirestore(),
        query,
        FirebaseChatCore.instance.config.usersCollectionName,
      ),
    );
  }

  Future loadRooms() async {
    loadingRooms.trigger(true);
    var supportUser = (await Get.find<FirebaseProvider>().getSupportUser());
    if (supportUser == null) {loadingRooms.trigger(false); return;};
    var stream = Get.find<AuthService>().user.value.moderatorOrAdmin
        ? supportRooms(supportUser)
        : FirebaseChatCore.instance.rooms();
    stream.listen((event) {
      rooms.assignAll(event);
      loadingRooms.trigger(false);
      if (rooms.isEmpty) {
      } else if (!Get.find<AuthService>().user.value.moderatorOrAdmin) {
        chatsPage.trigger(ChatPage(
          room: rooms.first,
        ));
      }
    });
  }

  Future refreshRooms() async {
    // await initializeFlutterFire();
    loadRooms();
  }


  Future initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        chatsPage.value = null;
        this.user.trigger(user);
        print('user changed');
      });
      initialized = true;
      loadRooms();
    } catch (e) {
        error = true;
    }
  }
}