import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:istnagram/state/comments/tpedefs/comment_id.dart';
import 'package:istnagram/state/constants/firebase_fields_name.dart';
import 'package:istnagram/state/posts/typedef/post_id.dart';
import 'package:istnagram/state/posts/typedef/user_id.dart';

@immutable
class Comment {
  final CommentId id;
  final String comment;
  final DateTime createdAt;
  final UserId fromUserId; // from this user
  final PostId onPostId; // the comment was on this posts

  Comment({required Map<String, dynamic> json, required this.id})
      : comment = json[FirebaseFieldName.comment],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
        fromUserId = json[FirebaseFieldName.userId],
        onPostId = json[FirebaseFieldName.postId];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Comment &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            comment == other.comment &&
            createdAt == other.createdAt &&
            fromUserId == other.fromUserId &&
            onPostId == other.onPostId;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hashAll([
        id,
        comment,
        onPostId,
        fromUserId,
        createdAt,
      ]);
}
