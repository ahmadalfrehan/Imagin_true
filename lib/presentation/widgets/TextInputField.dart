import 'package:flutter/material.dart';
import 'package:imagin_true/app/Config/Config.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Icon iconData;
  final bool? isPassword;

  const TextInputField({
    required this.hint,
    required this.controller,
    required this.iconData,
    this.isPassword,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: iconData,
          filled: isDark ? false : true,
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.white)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.white)),
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.white)),
          labelText: hint,
        ),
        controller: controller,
        keyboardType: TextInputType.text,
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'this field is required';
          }
          return null;
        },
      ),
    );
  }
}
