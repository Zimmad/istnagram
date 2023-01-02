import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/comments/notifiers/delete_comment_notifier.dart';
import 'package:istnagram/state/image_uploads/typedefs/is_loading.dart';

final deleteCommentProvider =
    StateNotifierProvider<DeleteCommentStateNotifier, IsLoading>(
  (ref) => DeleteCommentStateNotifier(),
);
