import 'package:flutter/material.dart';
import 'package:istnagram/state/posts/typedef/models/post.dart';

class PostThumbnailView extends StatelessWidget {
  const PostThumbnailView(
      {required this.onTapped, required this.post, Key? key})
      : super(key: key);
  final Post post;
  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: Image.network(
        post.thumbnailUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
