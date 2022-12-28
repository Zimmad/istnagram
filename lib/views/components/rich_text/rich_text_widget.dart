import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:istnagram/views/components/rich_text/link_text.dart';

import 'base_text.dart';

class RichTextWidget extends StatelessWidget {
  const RichTextWidget({
    super.key,
    required this.texts,
    this.styleForAll,
  });

  final Iterable<BaseText> texts;
  final TextStyle? styleForAll;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texts.map((e) {
          if (e is LinkText) {
            return TextSpan(
              text: e.text,
              style: styleForAll?.merge(e.style),
              recognizer: TapGestureRecognizer()..onTap = e.onTapped, //
            );
          } else {
            return TextSpan(
              text: e.text,
              style: styleForAll?.merge(e.style),
            );
          }
        }).toList(),
      ),
    );
  }
}
