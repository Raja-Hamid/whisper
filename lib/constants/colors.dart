import 'package:flutter/material.dart';

class CustomColors {
  static Color get primaryColor1 => const Color(0xff92A3FD);
  static Color get primaryColor2 => const Color(0xff9DCEFF);

  static Color get secondaryColor1 => const Color(0xffC58BF2);
  static Color get secondaryColor2 => const Color(0xffEEA4CE);

  static List<Color> get primaryButtonGradient =>
      [const Color(0xffe3a59d), const Color(0xffe39f96)];
  static List<Color> get welcomeButtonGradient =>
      [const Color(0xfff96d41), const Color(0xfffa521b)];
  static List<Color> get secondaryGradient =>
      [secondaryColor1, secondaryColor2];
  static List<Color> get bgGradient =>
      [const Color(0xff003f5c), const Color(0xffFF6E40)];

  static Color get black => const Color(0xff1D1617);
  static Color get white => Colors.white;
  static Color get grey => const Color(0xff786F72);
  static Color get lightGrey => const Color(0xffF7F8F8);
}
