import 'package:flutter/material.dart';

class ShowSnackBar {
  static showSnackBar({
    required BuildContext context,
    required String message,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.toString(),
        ),
        backgroundColor: color,
      ),
    );
  }
}
