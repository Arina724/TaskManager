import 'package:flutter/material.dart';

class MySnackbar {
  static SnackBar mySnackbar(String mes) {
    return SnackBar(
      content: Text(
        mes,
        style: const TextStyle(color: Colors.black,
      )),
      backgroundColor: const Color.fromARGB(255, 153, 4, 4),
    );
  }
}
