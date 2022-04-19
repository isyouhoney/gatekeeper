import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String labelText;
  final Icon suffixIcon;

  const Input({Key? key, required this.labelText, required this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: TextField(
        decoration:
            InputDecoration(labelText: labelText, suffixIcon: suffixIcon),
      ),
    );
  }
}
