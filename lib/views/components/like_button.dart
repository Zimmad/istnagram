import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/provider/user_id_provider.dart';
import 'package:istnagram/state/likes/models/like_dislike_request.dart';
import 'package:istnagram/state/likes/providers/has_liked_post.dart';
import 'package:istnagram/state/likes/providers/like_dislike_provider.dart';
import 'package:istnagram/state/posts/typedef/post_id.dart';
import 'package:istnagram/views/components/animations/small_error_animation_view.dart';

class LikeButton extends ConsumerWidget {
  const LikeButton({Key? key, required this.postId}) : super(key: key);
  final PostId postId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLiked = ref.watch(hasLikedPostProvider(postId));
    return hasLiked.when(
      data: (hasLiked) {
        return IconButton(
          icon: FaIcon(
            hasLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          ),
          onPressed: () {
            final userId = ref.read(userIdProvider);
            if (userId == null) {
              return;
            }
            final likeRequest =
                LikeDislikeRequest(postId: postId, likedBy: userId);
            ref.read(
              likeDislikeProvider(likeRequest),
            );
          },
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
    );
  }
}
