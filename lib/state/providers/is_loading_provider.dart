import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/auth/provider/auth_state_notifier_provider.dart';
import 'package:istnagram/state/comments/providers/delete_comment_provider.dart';
import 'package:istnagram/state/comments/providers/send_comment_provider.dart';
import 'package:istnagram/state/image_uploads/providers/image_uploader_provider.dart';
import 'package:istnagram/state/posts/providers/delete_post_provider.dart';

final isLoadingProvider = Provider<bool>(
  ((ref) {
    final authState = ref.watch(authStateProvider);
    final isUploadingImage = ref.watch(imageUpoadProvider);
    final isSendingComment = ref.watch(sendCommentProvider);
    final isDeletingComment = ref.watch(deleteCommentProvider);
    final isDeletingPost = ref.watch(deletePostProvider);

    return authState.isLoading ||
        isUploadingImage ||
        isDeletingPost ||
        isDeletingComment ||
        isSendingComment;
  }),
);
