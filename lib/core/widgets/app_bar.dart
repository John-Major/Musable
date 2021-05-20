import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  MyAppBar({this.title, this.leadingIcon, this.trailingIcon,});
  // Fields in a Widget subclass are always marked "final".
  final Widget title;
  final IconData leadingIcon;
  final IconData trailingIcon;
  @override
  Widget build(BuildContext context) {
    return AppBar(
       title: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           title,
           Icon(trailingIcon),
         ],
       ),
       leading: Icon(leadingIcon),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}