import 'package:flutter/material.dart';

class ShowMessage{
  static void notify(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.all(20),
        backgroundColor: Colors.pinkAccent,
        elevation: 4,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(text),
      ),
    );
  }
}