import 'package:flutter/cupertino.dart';
import 'package:istnagram/state/comments/models/comment.dart';
import 'package:istnagram/views/components/comment/compact_comment_tile.dart';

class CompactCommentsColumn extends StatelessWidget {
  const CompactCommentsColumn({super.key, required this.comments});
  final Iterable<Comment> comments;
  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: 8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: comments
              .map((comment) => CompactCommentTile(comment: comment))
              .toList(),
        ),
      );
    }
  }
}
