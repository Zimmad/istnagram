import 'package:flutter/foundation.dart'
    show immutable; // the show will import only the immutable

@immutable
class FirebaseFieldName {
  /// const private constructor
  const FirebaseFieldName._();

  static const userId = 'uid';
  static const postId = 'post_id';
  static const comment = 'comment';
  static const createdAt = 'created_at';
  static const date = 'date';
  static const displayName = 'display_name';
  static const email = 'email';
}
