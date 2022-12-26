import 'dart:html';

import 'package:flutter/foundation.dart' show immutable;

@immutable
class Strings {
  static const allowLikesTitle = 'Allow likes';
  static const allowLikesDiscription =
      'By allowing likes, users will be able to press like button on your post';
  static const allowLikesStorageKey = 'allow_likes';
  static const allowCommentsTitle = 'Allow comments';
  static const allowCommentsDiscription =
      'By allowing comments, users will be able to comment on your post';
  static const allowCommentsStorageKey = 'allow_comments';

  static const comment = 'comment';
  static const loading = 'Loading...';
  static const person = 'person';
  static const people = 'people';
  static const likedThis = 'liked this';
  static const delete = 'Delete';
  static const areYouSureThatYouWantToDeleteThis =
      'Are you sure that you want to delete this';
  static const logOut = 'Log Out';
  static const areYouSureThatYouWantToLogOutOfTheApp =
      'Are you sure that you want to log out of the app?';
  static const cancel = 'Cancel';

  const Strings._();
}
