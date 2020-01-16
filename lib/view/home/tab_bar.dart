import 'package:flutter/material.dart';

class ColoredTabBar extends Container implements PreferredSizeWidget {
  ColoredTabBar(this.color, this.tabBar);

  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Material(
        elevation: 25,
        child: Container(
          color: color,
          child: Material(
              elevation: 15, type: MaterialType.transparency, child: tabBar),
        ),
      );
}
