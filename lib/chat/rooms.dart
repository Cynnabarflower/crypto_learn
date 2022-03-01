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
import 'chat.dart';
import 'login.dart';
import 'users.dart';
import 'util.dart';
import 'package:crypto_learn/models/user.dart' as u;

class RoomsPage extends GetView<RoomsController> {

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
              (u) => u.id != controller.user.value!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
          name.isEmpty ? '' : name[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (controller.error) {
      return Container();
    }

    if (!controller.initialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.add),
          //   onPressed: _user == null
          //       ? null
          //       : () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //               fullscreenDialog: true,
          //               builder: (context) => const UsersPage(),
          //             ),
          //           );
          //         },
          // ),
        ],
        elevation: 0,
        backgroundColor: AppColors.backgroundGray,
        title: const Text('Support'),
      ),
      backgroundColor: AppColors.backgroundGray,
      body: Obx(
            () {
           if (controller.user.value == null) {
             return Container(
               alignment: Alignment.center,
               margin: const EdgeInsets.only(
                 bottom: 200,
               ),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Text('Not authenticated'),
                   TextButton(
                     onPressed: () {
                       Get.find<RootController>().changePage(3, animate: true);
                     },
                     child: const Text('Login'),
                   ),
                 ],
               ),
             );
           }

          if (controller.loadingRooms.isTrue) {
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('Loading...'),
            );
          }

          if (controller.rooms.isEmpty) {
            if (Get
                .find<AuthService>()
                .user
                .value
                .admin) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                child: const Text('Nothing here'),
              );
            }
            return InkWell(
              onTap: () => controller.handlePressed(context),
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                child: const Text('Tap to start chat with support'),
              ),
            );
          }

          if (controller.chatsPage.value != null) {
            return controller.chatsPage.value!;
          }

          if (controller.rooms.isNotEmpty) {
            return ListView.builder(
              itemCount: controller.rooms.length,
              itemBuilder: (context, index) {
                final room = controller.rooms[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(
                            title: const Text('Chat'),
                            backgroundColor: AppColors.backgroundGray,
                            elevation: 0,
                          ),
                          body: ChatPage(
                            room: room,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        _buildAvatar(room),
                        Text(room.name ?? ''),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              bottom: 200,
            ),
            child: const Text('Loading...'),
          );
        },
      ),
    );
  }

}
