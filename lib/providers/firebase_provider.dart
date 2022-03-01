import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_learn/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:crypto_learn/models/user.dart' as u;
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseProvider extends GetxService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<FirebaseProvider> init() async {
    return this;
  }

  Future update(u.User user) {
    print(_auth.currentUser?.uid);
    print('id: ${user.id}  uid: ${user.uid}');
   return _firestore.collection('users').doc(user.id).update(user.toJson());
  }

  Future<u.User?> getSupportUser() async {
    if (_auth.currentUser != null) {
      var us = await _firestore.collection('users').where('id', isEqualTo: 'support').get();
      if (us.size != 0) {
        var data = us.docs.first.data();
        data['id'] = us.docs.first.id;
        return u.User.fromJson(data);
      }
    }
    return null;
  }

  Future<u.User?> getCurrentUser() async {
    // return u.User(name: _auth.currentUser?.displayName, imaimageUrl: _auth.currentUser?.photoURL, id: _auth.currentUser?.uid);
    if (_auth.currentUser != null) {
      var us = await _firestore.collection('users').where('email', isEqualTo: _auth.currentUser!.email).get();
      if (us.size != 0) {
        var data = us.docs.first.data();
        data['id'] = us.docs.first.id;
        return u.User.fromJson(data);
      }
    }
    return null;
  }

  Future<bool> signInWithGoogle() async {
      GoogleSignInAccount? googleUser;
      if (kIsWeb) {
        googleUser = await GoogleSignIn(
          clientId: '527335365656-gf28vr6vod3htmqclfb73lv1j2185jkl.apps.googleusercontent.com',
        ).signIn();
      } else {
        googleUser = await GoogleSignIn().signIn();
      }
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      print('Google sign in: ${googleAuth}');
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var result = await _auth.signInWithCredential(credential);
      if (result.user != null) {
        print('CurrentUser: ${_auth.currentUser?.uid}');
        var existingUser = await _firestore.collection('users').where('email', isEqualTo: result.user!.email).get();
        if (existingUser.size == 0) {
          var userResult = await _firestore.collection('users').doc(result.user!.uid).set(
              u.User(
                id: result.user!.uid,
                uid: result.user!.uid,
                  email: result.user!.email,
                  firstName: result.user!.displayName,
                  lastName: '',
                  imageUrl: result.user!.photoURL,
              ).toJson(),
          );
        } else {

        }
        return true;
      } else {
        return false;
      }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return await signUpWithEmailAndPassword(email, password);
    }
  }



  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (result.user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future signOut() async {
    return await _auth.signOut();
  }
}
