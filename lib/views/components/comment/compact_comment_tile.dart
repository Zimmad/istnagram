import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/comments/models/comment.dart';
import 'package:istnagram/state/user_info/providers/user_info_provider.dart';
import 'package:istnagram/views/components/animations/small_error_animation_view.dart';
import 'package:istnagram/views/components/rich_two_parts_text.dart';

class CompactCommentTile extends ConsumerWidget {
  const CompactCommentTile({Key? key, required this.comment}) : super(key: key);
  final Comment comment;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider(comment.fromUserId));
    return userInfo.when(
      data: (userInfo) {
        return RichTwoPartsText(
            leftPart: userInfo.displayName, rightPart: comment.comment);
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
