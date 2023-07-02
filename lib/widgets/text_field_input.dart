import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final String label;
  final TextInputType textInputType;
  final bool isPass;
  final TextEditingController textEditingController;

  const TextFieldInput({
    required this.textEditingController,
    required this.label,
    required this.textInputType,
    this.isPass = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
      borderSide: Divider.createBorderSide(context),
    );
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 18.0),
        child: TextField(
          decoration: InputDecoration(
              focusColor: Colors.blue,
              fillColor: Colors.white,
              border: inputBorder,
              focusedBorder: inputBorder,
              enabledBorder: inputBorder,
              filled: true,
              contentPadding: const EdgeInsets.all(8),
              hintText: label),
          keyboardType: textInputType,
          controller: textEditingController,
          obscureText: isPass,
        ));
  }
}
