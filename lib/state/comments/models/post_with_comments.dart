import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:istnagram/state/comments/models/comment.dart';
import 'package:istnagram/state/posts/typedef/models/post.dart';

@immutable
class PostWithCommnets {
  final Post post;
  final Iterable<Comment> comments;

  const PostWithCommnets({required this.post, required this.comments});

  @override
  bool operator ==(covariant PostWithCommnets other) {
    return post == other.post &&
        const IterableEquality().equals(comments, other.comments);
  }

  @override
  int get hashCode => Object.hashAll(
        [post, comments],
      );
}
