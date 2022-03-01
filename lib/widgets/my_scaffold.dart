import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget{

  AppBar? appBar;
  Widget body;


  MyScaffold({this.appBar, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: body,
        ),
      ),
    );
  }
}