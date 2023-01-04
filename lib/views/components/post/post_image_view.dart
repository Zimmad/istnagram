import 'package:flutter/material.dart';

import '../../../state/posts/typedef/models/post.dart';

class PostImageView extends StatelessWidget {
  const PostImageView({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: post.aspectRatio,
      child: Image.network(
        post.fileUrl,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
