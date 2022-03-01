import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySignInButton extends StatelessWidget {

  Widget? child;
  VoidCallback? onTap;
  double? width;


  MySignInButton({this.child, this.onTap, this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blueGrey[800],
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}