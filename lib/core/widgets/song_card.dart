import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("song :)"),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      margin: EdgeInsets.all(2),
    );
  }
}