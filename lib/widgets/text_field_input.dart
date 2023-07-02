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
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      decoration: InputDecoration(
          border: inputBorder,
          focusedBorder: inputBorder,
          enabledBorder: inputBorder,
          filled: true,
          contentPadding: const EdgeInsets.all(8),
          hintText: label),
      keyboardType: textInputType,
      controller: textEditingController,
      obscureText: isPass,
    );
  }
}
