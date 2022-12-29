import 'dart:html';

import 'package:flutter/foundation.dart' show immutable;

@immutable
class Constants {
  static const allowLikesTitle = 'Allow likes';
  static const allowLikesDiscription =
      'By allowing likes, users will be able to press like button on your post';
  static const allowLikesStorageKey = 'allow_likes';
  static const allowCommentsTitle = 'Allow comments';
  static const allowCommentsDiscription =
      'By allowing comments, users will be able to comment on your post';
  static const allowCommentsStorageKey = 'allow_comments';
  const Constants._();
}
