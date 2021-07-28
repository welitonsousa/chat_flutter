import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  CustomAppBar({required this.label}) : preferredSize = Size.fromHeight(60.0);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.label),
      centerTitle: true,
    );
  }
}
