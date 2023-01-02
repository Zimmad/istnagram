import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/comments/notifiers/send_comment_notifier.dart';
import 'package:istnagram/state/image_uploads/typedefs/is_loading.dart';

final sendCommentProvider =
    StateNotifierProvider<SendCommentNotifier, IsLoading>(
  (ref) => SendCommentNotifier(),
);
