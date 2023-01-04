import 'package:flutter/material.dart';
import 'package:istnagram/state/image_uploads/models/file_type.dart';
import 'package:istnagram/state/posts/typedef/models/post.dart';
import 'package:istnagram/views/components/post/post_image_view.dart';
import 'package:istnagram/views/components/post/post_video_view.dart';

class PostImageOrVideoView extends StatelessWidget {
  const PostImageOrVideoView({Key? key, required this.post}) : super(key: key);
  final Post post;
  @override
  Widget build(BuildContext context) {
    switch (post.fileType) {
      case FileType.image:
        return PostImageView(post: post);
      case FileType.video:
        return PostVideoView(post: post);
      default:
        return const SizedBox();
    }
  }
}
