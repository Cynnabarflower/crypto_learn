import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_learn/models/user.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../providers/firebase_provider.dart';
import '../services/auth_service.dart';

class UserRepository {
  late FirebaseProvider _firebaseProvider;

  UserRepository() {}

  Future<User> getCurrentUser() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    // return this.get(Get.find<AuthService>().user.value);
    await Get.find<AuthService>().setCurrentUser(await _firebaseProvider.getCurrentUser());
    return Get.find<AuthService>().user.value;
  }

  Future<User> update(User user) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    await _firebaseProvider.update(user);
    return getCurrentUser();
  }


  Future<bool> signInWithGoogle() async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    if (await _firebaseProvider.signInWithGoogle()) {
      Get.find<AuthService>().setCurrentUser(await _firebaseProvider.getCurrentUser());
      return true;
    }
    return false;
  }


  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signInWithEmailAndPassword(email, password);
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    _firebaseProvider = Get.find<FirebaseProvider>();
    return _firebaseProvider.signUpWithEmailAndPassword(email, password);
  }

  // Future<void> verifyPhone(String smsCode) async {
  //   _firebaseProvider = Get.find<FirebaseProvider>();
  //   return _firebaseProvider.verifyPhone(smsCode);
  // }
  //
  // Future<void> sendCodeToPhone() async {
  //   _firebaseProvider = Get.find<FirebaseProvider>();
  //   return _firebaseProvider.sendCodeToPhone();
  // }

  Future signOut() async {
    await GoogleSignIn().disconnect();
    _firebaseProvider = Get.find<FirebaseProvider>();
    await _firebaseProvider.signOut();
    await getCurrentUser();
  }
}
