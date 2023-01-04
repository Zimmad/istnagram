import 'package:flutter/material.dart';
import 'package:istnagram/state/posts/typedef/models/post.dart';
import 'package:istnagram/views/components/post/post_thumbnail_view.dart';

import '../../post_detail/post_details_view.dart';

class PostSliverGridView extends StatelessWidget {
  const PostSliverGridView({super.key, required this.posts});
  final Iterable<Post> posts;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 8.0, crossAxisSpacing: 8.0),
      delegate: SliverChildBuilderDelegate(
        childCount: posts.length,
        (context, index) {
          final post = posts.elementAt(index);

          return PostThumbnailView(
              onTapped: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PostDetailsView(post: post);
                    },
                  ),
                );
              },
              post: post);
        },
      ),
    );
  }
}
