import 'package:flutter/foundation.dart'
    show immutable; // the show will import only the immutable

@immutable
class FirebaseCollectionName {
  /// const private constructor
  const FirebaseCollectionName._();

  /// [tumbnails] will be stored in the [firebase storage] not in firestore
  static const tumbnails = 'tumbnails';
  static const likes = 'likes';
  static const posts = 'posts';
  static const users = 'users';
  static const comments = 'comments';
}
