import 'package:flutter/material.dart';
import 'package:istnagram/extensions/strings/remove_all.dart';

/// Convert 0x?????? and #?????? to Color
extension AsHtmlColorToColor on String {
  Color htmlColorToColor() => Color(
        int.parse(
          removeAll(['0x', '#']).padLeft(8, 'ff'),
          radix: 16,
        ),
      );
}
