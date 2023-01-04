import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/likes/providers/post_count_likes_provider.dart';
import 'package:istnagram/state/posts/typedef/post_id.dart';
import 'package:istnagram/views/components/animations/small_error_animation_view.dart';
import 'package:istnagram/views/components/constants/strings.dart';

class LikesCountView extends ConsumerWidget {
  const LikesCountView({super.key, required this.postId});
  final PostId postId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(postLikesCountProvider(postId));
    return likesCount.when(
      data: (int likes) {
        final personOrPeople = likes == 1 ? Strings.person : Strings.people;
        final String likesText = '$likes $personOrPeople ${Strings.likedThis}';
        return Text(likesText);
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
