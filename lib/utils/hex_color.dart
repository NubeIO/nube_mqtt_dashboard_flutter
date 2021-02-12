import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

class HexColor {
  @nullable
  static Color parseColor(String color) {
    try {
      var output = color.toUpperCase().replaceAll("#", "");
      if (color.length == 6) {
        output = "FF$color";
      }

      return Color(int.parse(output, radix: 16));
    } catch (e) {
      return null;
    }
  }
}
