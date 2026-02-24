import 'package:flutter/material.dart';

class BaseSnackBar extends SnackBar {
  BaseSnackBar({required super.content});

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [content],
      ),
    );
  }
}
