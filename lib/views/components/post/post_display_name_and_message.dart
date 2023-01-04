import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/posts/typedef/models/post.dart';
import 'package:istnagram/state/user_info/providers/user_info_provider.dart';
import 'package:istnagram/views/components/animations/small_error_animation_view.dart';
import 'package:istnagram/views/components/rich_two_parts_text.dart';

class PostDisplayNameAndMessage extends ConsumerWidget {
  const PostDisplayNameAndMessage({Key? key, required this.post})
      : super(key: key);
  final Post post;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoModel = ref.watch(userInfoProvider(post.userId));
    return userInfoModel.when(
      data: (userInfoModel) {
        return Padding(
            padding: const EdgeInsets.all(8),
            child: RichTwoPartsText(
                leftPart: userInfoModel.displayName, rightPart: post.message));
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
