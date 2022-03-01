import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_learn/helper.dart';
import 'package:crypto_learn/models/post.dart';

class PostRepository {
  late FirebaseFirestore _firestore;


  PostRepository() {
    _firestore = FirebaseFirestore.instance;
  }

  Future delete(String id) {
    return _firestore.collection('posts').doc(id).delete();
  }

  Future<Iterable<Post>> getPosts({String? query, Post? startAfter, int? limit}) async {
    Query<Map<String, dynamic>> queue = _firestore.collection('posts');
    query = query?.trim().toLowerCase();
    print('searching: ${query}');
    // var allDocs = await _firestore.collection('posts').orderBy('date',descending: true).get();
    if (query != null && query.isNotEmpty) {
      queue = queue
          // .where('query', isGreaterThanOrEqualTo: query.toLowerCase()).orderBy('query');
      .where('tags')
          .where('query', arrayContainsAny: query.split(' '));//.orderBy('query');
    }
    if (startAfter != null) {
      queue = queue.startAfterDocument(await _firestore.doc('posts/${startAfter.id}').get());
    }
    queue = queue.limit(limit ?? 10);

    var rawPosts = (await queue.get()).docs;
    print('Found ${rawPosts.length}');
    return rawPosts.map((e) {
      var data = e.data();
      data['id'] = e.id;
      return Post.fromJson(data);
    });
  }

  Future<Post?> upsert(Post post) async {
    var ref =  _firestore.collection('posts').doc(post.id.isEmpty ? null : post.id);
    await ref.set(post.toJson());
    var data = (await ref.get()).data();
    if (data != null) {
      data['id'] = ref.id;
      return Post.fromJson(data);
    }
    return null;
  }

}



// Future<Iterable<Post>> getPosts({String? query, Post? startAfter, int? limit}) async {
//   var collection = _firestore.collection('posts');
//   // var allDocs = await _firestore.collection('posts').orderBy('date',descending: true).get();
//   List<QueryDocumentSnapshot<Map<String, dynamic>>> rawPosts;
//   if (query != null && query.trim().isNotEmpty) {
//     var queueQuery = collection.where('query', isGreaterThanOrEqualTo: query).orderBy('query').orderBy('date',descending: true);
//     var queueBody = collection.where('body', isGreaterThanOrEqualTo: query).orderBy('body').orderBy('date',descending: true);
//     var queueTags = collection.where('tags', arrayContainsAny: query.split(' ')).orderBy('tags').orderBy('date',descending: true);
//     if (startAfter != null) {
//       queueQuery = queueQuery.startAfterDocument(await _firestore.doc('posts/${startAfter.id}').get());
//       queueBody = queueBody.startAfterDocument(await _firestore.doc('posts/${startAfter.id}').get());
//       queueTags = queueTags.startAfterDocument(await _firestore.doc('posts/${startAfter.id}').get());
//     }
//
//     rawPosts = (await queueQuery.snapshots()
//         .combine(queueBody.snapshots())
//         .combine(queueTags.snapshots())
//         .take(limit ?? 5)
//         .expand((e) => e)
//         .map((event) => event.docs)
//         .expand((element) => element)
//         .toSet()).toList();
//   } else {
//     Query<Map<String, dynamic>> queue;
//     if (startAfter != null) {
//       queue = collection.orderBy('date',descending: true).startAfterDocument(await _firestore.doc('posts/${startAfter.id}').get());
//     } else {
//       queue = collection.orderBy('date',descending: true);
//     }
//     queue = queue.limit(limit ?? 5);
//     rawPosts = (await queue.get()).docs;
//   }
//   print(rawPosts.map((e) => e.data()));
//   return rawPosts.map((e) {
//     var data = e.data();
//     data['id'] = e.id;
//     return Post.fromJson(data);
//   });
// }