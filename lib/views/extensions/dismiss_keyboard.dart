import 'package:flutter/material.dart';

/// This [extension] is [on] any [Widget]
extension DismissedKeyboard on Widget {
  void dismissKeyboard() => FocusManager.instance.primaryFocus?.unfocus();
}
