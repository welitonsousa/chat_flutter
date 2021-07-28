import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final bool enable;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final int maxLines;
  final Widget? trailing;
  final Function(String)? onChange;

  const CustomInput({
    this.onChange,
    this.trailing,
    this.label = "",
    this.controller,
    this.maxLines = 1,
    this.enable = true,
    this.textInputAction = TextInputAction.newline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        enabled: this.enable,
        maxLines: this.maxLines,
        minLines: 1,
        onChanged: onChange,
        textInputAction: this.textInputAction,
        cursorColor: Colors.transparent,
        controller: this.controller,
        decoration: new InputDecoration(
          suffix: this.trailing,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(
            left: 15,
            bottom: 15,
            top: 15,
          ),
          hintText: this.label,
        ),
      ),
    );
  }
}
