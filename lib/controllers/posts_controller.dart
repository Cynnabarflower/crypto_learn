import 'dart:convert';
import 'dart:io' as io;

import 'package:crypto_learn/models/post.dart';
import 'package:crypto_learn/repositories/posts_repository.dart';
import 'package:file_picker/file_picker.dart';

//Move to separate repo
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as htmlparser;

class PostsController extends GetxController {
  final PostRepository _postRepository = PostRepository();

  Future<Iterable<Post>> getPosts(
      {String? query, Post? startAfter, int? limit}) {
    return _postRepository.getPosts(
        query: query, startAfter: startAfter, limit: limit);
  }

  Future deletePost(Post post) {
    return _postRepository.delete(post.id);
  }

  Future<Post?> upsert(Post post,
      {Map<String, PlatformFile>? images, PlatformFile? titleImage}) async {
    if (images != null && images.isNotEmpty) {
      var parsed = htmlparser.parse(post.body);
      var children = parsed.getElementsByTagName("img");
      for (var element in children) {
        if (element.attributes['src']?.contains('base64') ?? false) {
          var filename = element.attributes['data-filename']!;
          if (images[filename] != null) {
            var path = await uploadFile(images[filename]!);
            element.attributes['src'] = path;
            // element.replaceWith(dom.Element.tag('img')..attributes['src'] = path);
          } else {
            var bytes = base64Decode(element.attributes['src']!.split(r';base64,').last);
            var file = PlatformFile(name: filename, size: bytes.length, bytes: bytes,path: filename);
            var path = await uploadFile(file);
            element.attributes['src'] = path;
          }
        }
      }
      post.body = parsed.outerHtml;
    }
    if (titleImage != null) {
      var path = await uploadFile(titleImage);
      post.titleImageUrl = path;
    }
    if (true || post.query.isEmpty) {
      post.query = <String>{...post.tags, ...post.title.toLowerCase().split(' '), ...post.onlyText().split(' ')}
      .map((e) => e.replaceAll(RegExp("[^0-9a-zA-Zа-ЯА-Я-]+", caseSensitive: false), ''))
      .where((element) => element.length >= 3)
          .where((element) => element.length < 20)
          .take(1000).toList();
      // post.query = post.tags.join('') + post.title + post.onlyText();
      // post.query = post.query.removeAllWhitespace.replaceAll(RegExp('[.,;!?@\$]'), '');
    }
    return _postRepository.upsert(post);
  }

  Future<String> uploadFile(PlatformFile file) async {
    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('/${file.hashCode}');

    if (kIsWeb) {
      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': ''});
      uploadTask = ref.putData(file.bytes!, metadata);
    } else {
      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': file.path!});
      uploadTask = ref.putFile(io.File(file.path!), metadata);
    }

    return (await uploadTask).ref.getDownloadURL();
  }
}
