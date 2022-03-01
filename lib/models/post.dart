import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:html/parser.dart' as htmlparser;

class Post {
  String id = '';
  String title = '';
  String? titleImageUrl;
  String body = '';
  List<String> tags = [];
  DateTime? date;
  var likes = 0.obs;
  List<String> query = [];

  Post();
  
  String withoutImages() {
    var parsed = htmlparser.parse(body);
    var children = parsed.getElementsByTagName("img");
    for (var element in children) {
      element.remove();
    }
    return parsed.outerHtml;
  }

  String onlyText() {
    final document = htmlparser.parse(body);
    final String parsedString = htmlparser.parse(document.body!.text).documentElement!.text;
    return parsedString.toLowerCase();//.split(' ').toSet().join('');
  }

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    query = List<String>.from(json['query'] ?? []);
    titleImageUrl = json['titleImage'];
    body = json['body'];
    tags = List<String>.from(((json['tags'] ?? []) as List));
    date = (json['date'] as Timestamp?)?.toDate();
    likes.trigger(json['likes'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['query'] = query;
    data['titleImage'] = titleImageUrl;
    data['body'] = body;
    data['tags'] = tags;
    data['date'] = date == null ? null : Timestamp.fromDate(date!);
    data['likes'] = likes.value;
    return data;
  }
}