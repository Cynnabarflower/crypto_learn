import 'package:crypto_learn/config.dart';
import 'package:crypto_learn/controllers/search_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchWidget extends GetView<SearchController> {

  TextEditingController textEditingController = TextEditingController();


  SearchWidget(text) {
    textEditingController.text = text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      onSubmitted: (value) {
        controller.query.trigger(value);
        controller.refreshSearch(query: value);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.widgetGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none
        ),
      ),
    );
  }



}