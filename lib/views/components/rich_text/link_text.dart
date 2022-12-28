import 'package:flutter/foundation.dart' show immutable, VoidCallback;
import 'package:istnagram/views/components/rich_text/base_text.dart';

@immutable
class LinkText extends BaseText {
  final VoidCallback onTapped; // VoidCallback is typeDef of 'void Function'
  const LinkText({
    required super.text,
    required this.onTapped,
    super.style,
  });
}
