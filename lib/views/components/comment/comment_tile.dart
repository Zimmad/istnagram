import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/provider/user_id_provider.dart';
import 'package:istnagram/state/comments/models/comment.dart';
import 'package:istnagram/state/comments/providers/delete_comment_provider.dart';
import 'package:istnagram/state/user_info/providers/user_info_provider.dart';
import 'package:istnagram/views/components/animations/small_error_animation_view.dart';
import 'package:istnagram/views/components/constants/strings.dart';
import 'package:istnagram/views/components/dialog/alert_dialog_model.dart';
import 'package:istnagram/views/components/dialog/delete_dialoge.dart';

class CommentTile extends ConsumerWidget {
  const CommentTile({required this.comment, super.key});
  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoProvider(comment.fromUserId),
    );
    return userInfo.when(
      data: (userInfoModel) {
        final currenUserId = ref.read(
            userIdProvider); // userId of the current user. ref.read  only reads the value when the wediget build
        return ListTile(
          trailing: currenUserId == comment.fromUserId
              ? IconButton(
                  onPressed: () async {
                    final shouldDelteComment =
                        await displayDeleteDialog(context);
                    if (shouldDelteComment) {
                      await ref
                          .read(deleteCommentProvider.notifier)
                          .deleteComment(commentId: comment.id);
                    }
                  },
                  icon: const Icon(Icons.delete),
                )
              : null,
          title: Text(userInfoModel.displayName),
          subtitle: Text(comment.comment),
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

  Future<bool> displayDeleteDialog(BuildContext context) {
    return DeleteDialog(titleObjectToDelete: Strings.comment)
        .present(context)
        .then((value) => value ?? false);
  }
}
