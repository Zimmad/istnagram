import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;
import 'package:istnagram/state/constants/firebase_fields_name.dart';
import 'package:istnagram/state/posts/typedef/post_id.dart';
import 'package:istnagram/state/posts/typedef/user_id.dart';

@immutable
class Like extends MapView<String, String> {
  Like({
    required PostId postId,
    required UserId likedBy,
    required DateTime dateTime,
  }) : super({
          FirebaseFieldName.postId: postId,
          FirebaseFieldName.userId: likedBy,
          FirebaseFieldName.createdAt: dateTime.toIso8601String()
        });
}
