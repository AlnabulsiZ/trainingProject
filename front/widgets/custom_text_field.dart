import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType inputType;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.inputType = TextInputType.text,
    this.isPassword = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.blue.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}