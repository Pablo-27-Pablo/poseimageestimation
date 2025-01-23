import 'package:flutter/material.dart';






//small Gap

const smallGap = SizedBox(
  height: 15,
);

//large Gap
const largeGap = SizedBox(
  height: 30,
);

extension ShowSnackBar on BuildContext {
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.redAccent),
        ),
        backgroundColor: Colors.grey,
      ),
    );
  }
}
