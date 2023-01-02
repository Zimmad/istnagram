import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:istnagram/state/image_uploads/notifiers/image_upload_notifier.dart';
import 'package:istnagram/state/image_uploads/typedefs/is_loading.dart';

final imageUpoadProvider =
    StateNotifierProvider<ImageUploadNotifier, IsLoading>(
  (ref) => ImageUploadNotifier(),
);
