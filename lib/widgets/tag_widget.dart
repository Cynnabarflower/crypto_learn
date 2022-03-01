import 'package:flutter/cupertino.dart';

class TagWidget extends StatelessWidget {

  String tag;


  TagWidget(this.tag);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(
              255,
              150 + (tag.hashCode % 100),
              120 + ((tag.hashCode + 123) % 80),
              120 + ((tag.hashCode + 456) % 80)),
          borderRadius:
          BorderRadius.all(Radius.circular(16.0))),
      padding: const EdgeInsets.symmetric(
          vertical: 4, horizontal: 12),
      child: Text(tag),
    );
  }

}