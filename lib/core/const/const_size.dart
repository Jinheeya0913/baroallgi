import 'package:flutter/material.dart';

class AppSizes {
  static const double s14 = 14.0;
  static const double normal = 16.0;
  static const double s20 = 20.0;
  static const double s40 = 40.0;
  static const double fontNormal = 12.0;
  static const double fontBig = 16.0;
}

class SizeUtil {
  static double getFloatingButtonSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.9;
  }
}
