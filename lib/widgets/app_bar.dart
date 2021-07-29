import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String label;
  final List<Widget>? actions;
  CustomAppBar({required this.label, this.actions})
      : preferredSize = Size.fromHeight(60.0);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.label),
      centerTitle: true,
      actions: this.actions,
    );
  }
}
