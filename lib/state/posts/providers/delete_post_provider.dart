import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/image_uploads/typedefs/is_loading.dart';
import 'package:istnagram/state/posts/notifiers/delete_post_state_notifier.dart';

final deletePostProvider =
    StateNotifierProvider<DeletePostStateNotifier, IsLoading>(
  (ref) => DeletePostStateNotifier(),
);
